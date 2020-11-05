<template>
  <section id="tasks-index">
    <h1 id="tasks-index-title">Your Tasks</h1>
    <div id="task-new-button-container">
      <button @click="getTodosAndUsers()" id="refresh">
        <i class="fas fa-redo-alt"></i>
      </button>
      <button @click="is_search = !is_search" id="search-button">
        <i class="fas fa-search"></i>
      </button>
      <transition name="fade">
        <div v-show="is_search" id="search-container">
          <div id="search-close-container">
            <span id="search-close" @click="is_search = false">×</span>
          </div>
          <Search :tasks.sync="tasks" :tags="tags" :is_search.sync="is_search"></Search>
        </div>
      </transition>
      <div id="pulldown-container">
        <dropdown-menu v-model="dropdown_show" :hover="hover" :interactive="interactive">
          <button>{{ sort_property }}</button>
          <div slot="dropdown" id="pulldown">
            <button @click="sortClicked(1)">締め切りが早い順</button>
            <button @click="sortClicked(2)">締め切りが遅い順</button>
            <button @click="sortClicked(3)">優先度が高い順</button>
            <button @click="sortClicked(4)">優先度が低い順</button>
          </div>
        </dropdown-menu>
      </div>
      <span id="task-new-button" @click="newFunc()">Add a Task</span>
    </div>
    <div
      v-if="tasks && users"
      v-show="!is_show && !is_new_and_edit && !is_search"
      id="tasks-container"
    >
      <paginate name="paginate-task" :list="sorted_tasks" :per="per">
        <li v-for="(task, index) in paginated('paginate-task')" :key="index" class="each-todo">
          <TaskListCard
            :task="task"
            :tags="tags"
            :show-func="showFunc"
            :edit-func="editFunc"
            :refreshTasksAllData="refreshTasksAllData"
          ></TaskListCard>
        </li>
      </paginate>
      <div id="how-many-tasks">
        <button @click="per = 10" :class="{ displayedNumActive: per === 10 }">10件表示</button>
        <button @click="per = 30" :class="{ displayedNumActive: per === 30 }">30件表示</button>
        <button @click="per = 50" :class="{ displayedNumActive: per === 50 }">50件表示</button>
        <button @click="per = 100" :class="{ displayedNumActive: per === 100 }">100件表示</button>
      </div>
      <paginate-links for="paginate-task" class="pagination" :show-step-links="true"></paginate-links>
    </div>
    <transition name="fade">
      <div
        v-if="whichTaskIsLookedInShow"
        v-show="is_show"
        id="task-show-modal-container"
        class="modal-container"
      >
        <!-- showページのモーダルです -->
        <TaskShow
          :task="whichTaskIsLookedInShow"
          :user="relatedUser(whichTaskIsLookedInShow.user_id)"
          :tags="tags"
          :is_show.sync="is_show"
        ></TaskShow>
      </div>
    </transition>
    <transition name="fade">
      <div
        v-if="taskNewOrEdit"
        v-show="is_new_and_edit"
        id="task-new-and-edit-modal-container"
        class="modal-container"
      >
        <!-- newとeditページのモーダルです -->
        <TaskNewAndEdit
          :task="taskNewOrEdit"
          :tags="tags"
          :is_new_and_edit.sync="is_new_and_edit"
          :is_new="is_new"
          :refresh-tasks-all-data="refreshTasksAllData"
        ></TaskNewAndEdit>
      </div>
    </transition>
  </section>
</template>
<script>
"use strict";
import TaskListCard from "../../components/tasks/TaskListCard";
import TaskShow from "../../components/tasks/Show";
import TaskNewAndEdit from "../../components/tasks/NewAndEdit.vue";
import DropdownMenu from "@innologica/vue-dropdown-menu";
import Search from "../../components/tasks/Search";

export default {
  components: {
    TaskListCard,
    TaskShow,
    TaskNewAndEdit,
    DropdownMenu,
    Search,
  },
  data() {
    return {
      tasks: null,
      tags: null,
      users: null,
      whichTaskIsLookedInShow: null,
      taskNewOrEdit: {
        title: "",
        content: "",
        status: 1,
        deadline: "",
        important: false,
      },
      sort_property: "締め切りが早い順",
      is_show: false,
      is_new_and_edit: false,
      is_new: true,
      dropdown_show: false,
      hover: false,
      interactive: false,
      is_search: false,
      paginate: ["paginate-task"],
      per: 10,
    };
  },
  created() {
    this.getTodosAndUsers();
  },
  methods: {
    getTodosAndUsers() {
      const url = "/api/tasks";
      const token = this.$store.getters["auth/token"];
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        Authorization: "Token " + token,
      };
      this.axios
        .get(url)
        .then((response) => {
          this.tasks = Object.freeze(response.data.tasks); //再代入を禁止にした。これがないと、v-modelの作用がglobalに影響を与えてしまうバグがでた。
          this.tags = response.data.tags
          this.users = response.data.users;
        })
        .catch((error) => {
          console.log(error);
          alert("エラーが起きました！");
        });
    },
    showFunc(task) {
      this.whichTaskIsLookedInShow = task;
      this.is_show = true;
    },
    editFunc(task) {
      this.taskNewOrEdit = task;
      this.is_new = false;
      this.is_new_and_edit = true;
    },
    newFunc() {
      this.taskNewOrEdit = {
        // taskNewOrEditを初期化
        title: "",
        content: "",
        status: 1,
        deadline: "",
        important: false,
      };
      this.is_new = true;
      this.is_new_and_edit = true;
    },
    refreshTasksAllData(data) {
      this.tasks = data.tasks;
      this.users = data.users;
    },
    sortClicked(property) {
      if (property === 1) {
        this.sort_property = "締め切りが早い順";
      } else if (property === 2) {
        this.sort_property = "締め切りが遅い順";
      } else if (property === 3) {
        this.sort_property = "優先度が高い順";
      } else if (property === 4) {
        this.sort_property = "優先度が低い順";
      }
      this.dropdown_show = false;
    },
  },
  computed: {
    relatedUser: function () {
      return function (task_id) {
        for (let i = 0; i < this.users.length; i++) {
          if (this.users[i]["id"] === task_id) {
            return this.users[i];
          }
        }
      };
    },
    sorted_tasks: function () {
      const array = this.tasks.map((el) => el);
      if (this.tasks) {
        if (this.sort_property === "締め切りが早い順") {
          const sorted = array.sort((a, b) => {
            return a.deadline > b.deadline ? 1 : -1;
          });
          return sorted;
        } else if (this.sort_property === "締め切りが遅い順") {
          const sorted = array.sort((a, b) => {
            return a.deadline < b.deadline ? 1 : -1;
          });
          return sorted;
        } else if (this.sort_property === "優先度が高い順") {
          const sorted = array.sort((a, b) => {
            return a.important > b.important ? 1 : -1;
          });
          return sorted;
        } else if (this.sort_property === "優先度が低い順") {
          const sorted = array.sort((a, b) => {
            return a.important < b.important ? 1 : -1;
          });
          return sorted;
        }
      }
    },
  },
};
</script>
<style>
.pagination.paginate-links {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin: 0 auto;
}
.pagination.paginate-links > li.number {
  list-style: none;
  background-color: white;
  margin: 0 10px 10px 10px;
}
.pagination.paginate-links > li.number > a {
  display: inline-block;
  padding: 5px 10px;
  border: 1px solid #53c500;
  cursor: pointer;
}
.pagination.paginate-links > li.left-arrow {
  list-style: none;
  cursor: pointer;
  background-color: white;
  margin: 0 10px 10px 10px;
}
.pagination.paginate-links > li.left-arrow > a {
  display: inline-block;
  padding: 5px 10px;
  border: 1px solid #53c500;
}
.pagination.paginate-links > li.right-arrow {
  list-style: none;
  cursor: pointer;
  background-color: white;
  margin: 0 10px 10px 10px;
}
.pagination.paginate-links > li.right-arrow > a {
  display: inline-block;
  padding: 5px 10px;
  border: 1px solid #53c500;
}
.pagination.paginate-links > li.ellipses {
  list-style: none;
  margin: 0;
  margin: 0 10px 10px 10px;
}
.pagination > .number.active > a {
  background-color: #53c500;
  color: white;
}
</style>
<style lang="scss" scoped>
$link-color: #186de9;
$new-button-border-color: #186de9;
$modal-background: rgba(0, 0, 0, 0.3);
a {
  text-decoration: none;
  color: $link-color;
}

@media only screen and (max-width: 1365px) {
}
@media screen and (min-width: 1366px) {
  #tasks-index {
    padding-bottom: 50px;
    box-sizing: border-box;
    #tasks-index-title {
      font-size: 1.8rem;
      text-align: center;
    }
    #task-new-button-container {
      width: 70%;
      display: flex;
      flex-direction: row;
      justify-content: flex-end;
      margin: 50px auto 0 auto;
      #search-button {
        font-size: 1.1rem;
        display: inline-block;
        margin-right: 30px;
        border: 2px solid $new-button-border-color;
        padding: 10px 20px;
        background-color: white;
        cursor: pointer;
      }
      #refresh {
        font-size: 1.1rem;
        display: inline-block;
        margin-right: 30px;
        border: 2px solid $new-button-border-color;
        padding: 10px 20px;
        background-color: white;
        cursor: pointer;
      }
      #search-container {
        width: 100vw;
        height: 100vh;
        padding: 100px;
        box-sizing: border-box;
        display: flex;
        flex-direction: column;
        align-items: center;
        position: absolute;
        background-color: white;
        top: 0;
        right: 0;
        z-index: 5;
        #search-close-container {
          width: 100%;
          display: flex;
          flex-direction: row;
          align-items: center;
          justify-content: flex-end;
          padding-right: 80px;
          box-sizing: border-box;
          #search-close {
            font-size: 4rem;
            cursor: pointer;
          }
        }
      }
      #pulldown-container {
        position: relative;
        button {
          font-size: 1.2rem;
          display: inline-block;
          margin-right: 30px;
          border: 2px solid $new-button-border-color;
          padding: 10px 20px;
          background-color: white;
          cursor: pointer;
        }
        #pulldown {
          position: absolute;
          top: 60px;
          z-index: 2;
          display: flex;
          flex-direction: column;
          button {
            display: inline-block;
            margin-top: 10px;
            &:hover {
              background: $new-button-border-color;
              color: white;
            }
          }
        }
      }
      #task-new-button {
        font-size: 1.2rem;
        display: inline-block;
        margin-right: 30px;
        border: 2px solid $new-button-border-color;
        padding: 10px 20px;
        &:hover {
          cursor: pointer;
        }
      }
    }
    #tasks-container {
      display: flex;
      flex-direction: column;
      align-items: center;

      ul {
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        .each-todo {
          width: 70%;
          margin: 20px 0;
          cursor: pointer;
          transition: all 0.5s;
          list-style: none;
          &:hover {
            transform: scale(1.02, 1.02);
          }
        }
      }
      .pagination {
        width: 100%;
        display: flex;
        flex-direction: row;
        justify-content: center;
      }
      #how-many-tasks {
        display: flex;
        flex-direction: row;
        justify-content: center;
        button {
          background-color: white;
          padding: 5px 10px;
          border: 1px solid #53c500;
          margin: 10px;
          cursor: pointer;
          &:hover {
            background-color: #53c500;
            color: white;
          }
        }
        button.displayedNumActive {
          background-color: #53c500;
          color: white;
        }
      }
    }
    .modal-container {
      position: absolute;
      top: 0;
      left: 0;
      z-index: 2;
      width: 100%;
      height: 100vh;
      background-color: $modal-background;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: flex-start;
      padding-top: 100px;
      box-sizing: border-box;
    }
  }
}
</style>
