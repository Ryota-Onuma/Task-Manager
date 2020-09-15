<template>
  <section id="tasks-index">
    <h1 id="tasks-index-title">Your Tasks</h1>
    <div id="task-new-button-container">
      <span id="task-new-button" @click="newFunc()">Add a Task</span>
    </div>
    <div
      v-if="tasks && users"
      v-show="!is_show && !is_new_and_edit"
      id="tasks-container"
    >
      <span
        v-for="(task, index) in sorted_tasks"
        :key="index"
        class="each-todo"
      >
        <TaskListCard
          :task="task"
          :show-func="showFunc"
          :edit-func="editFunc"
          :refreshTasksAllData="refreshTasksAllData"
        ></TaskListCard>
      </span>
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

export default {
  components: {
    TaskListCard,
    TaskShow,
    TaskNewAndEdit,
  },
  data() {
    return {
      tasks: null,
      users: null,
      whichTaskIsLookedInShow: null,
      taskNewOrEdit: {
        title: "",
        content: "",
        status: 1,
        deadline: "",
        important: false,
      },
      sort_property: "asc",
      is_show: false,
      is_new_and_edit: false,
      is_new: true,
    };
  },
  created() {
    this.getTodosAndUsers();
  },
  methods: {
    getTodosAndUsers() {
      const url = "/api/tasks";
      this.axios
        .get(url)
        .then((response) => {
          this.tasks = Object.freeze(response.data.tasks); //再代入を禁止にした。これがないと、v-modelの作用がglobalに影響を与えてしまうバグがでた。
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
        if (this.sort_property === "asc") {
          const sorted = array.sort((a, b) => {
            return a.deadline < b.deadline ? 1 : -1;
          });
          return sorted;
        } else if (this.sort_property === "desc") {
          const sorted = array.sort((a, b) => {
            return a.deadline > b.deadline ? 1 : -1;
          });
          return sorted;
        }
      }
    },
  },
};
</script>
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
      #task-new-button {
        font-size: 1.6rem;
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
      .each-todo {
        width: 70%;
        margin: 20px 0;
        cursor: pointer;
        transition: all 0.5s;
        &:hover {
          transform: scale(1.02, 1.02);
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
