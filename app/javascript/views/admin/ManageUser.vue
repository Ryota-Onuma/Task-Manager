<template>
  <section id="management-user">
    <h2 id="management-user-title">Manage User</h2>
    <div id="buttons">
      <button id="edit" @click="is_edit = !is_edit">
        {{ is_edit ? "Cansell Edit" : "Edit" }}
      </button>
      <button id="delete" @click="destroy">Delete</button>
    </div>
    <div id="user-infomation" v-show="!is_edit">
      <h4><span class="header">Name：</span> {{ user.name }}</h4>
      <h4><span class="header">Email: </span>{{ user.email }}</h4>
      <h4>
        <span class="header">Permission: </span> {{ user.permission | status }}
      </h4>
      <h4><span class="header">Role: </span> {{ user.admin | role }}</h4>
      <h4><span class="header">Introduction</span></h4>
      <div id="introduction">
        {{ user.introduction }}
      </div>
    </div>
    <div id="edit-user-infomation" v-show="is_edit">
      <div>
        <label for="name">Name：</label>
        <input type="text" id="name" v-model="user.name" />
      </div>
      <div>
        <label for="email">Email：</label>
        <input type="email" id="email" v-model="user.email" />
      </div>
      <div>Permission</div>
      <div class="radio-container">
        <div>
          <label
            ><input type="radio" v-model="user.permission" :value="true" />
            Approve</label
          >
        </div>
        <div>
          <label
            ><input type="radio" v-model="user.permission" :value="false" />
            Ban</label
          >
        </div>
      </div>
      <div>Admin</div>
      <div class="radio-container">
        <div>
          <label
            ><input
              type="radio"
              v-model="user.admin"
              :value="true"
            />Admin</label
          >
        </div>
        <div>
          <label
            ><input
              type="radio"
              v-model="user.admin"
              :value="false"
            />Nomal</label
          >
        </div>
      </div>
      <div id="edit-confirm">
        <button @click="submit">Update</button>
      </div>
    </div>
    <h3 id="this-user-task">{{ user.name }}のタスク</h3>
    <div class="todo-card" v-for="(task, i) in tasks" :key="i">
      <span class="todo-created-at">
        <span style="background: red; color: white; padding: 5px;">〆</span>
        {{ task.deadline | convert_time_format }}
      </span>
      <span class="task-title">{{ task.title }}</span>
      <div class="task-card-buttons">
        <span class="status-marker">
          <span v-if="task.status === 1" class="yet">Yet</span>
          <span v-else-if="task.status === 2" class="doing">Doing</span>
          <span v-else-if="task.status === 3" class="done">Done</span>
        </span>
        <span class="status-marker">
          <span v-if="task.important === 1" class="yet">Priority High</span>
          <span v-else-if="task.important === 2" class="doing"
            >Priority Middle</span
          >
          <span v-else-if="task.important === 3" class="done"
            >Priority Low</span
          >
        </span>
        <span class="show-task-button" @click="SetShowFunc(task)">
          <i class="fas fa-info-circle"></i>
        </span>
      </div>
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
          :user="user"
          :is_show.sync="is_show"
        ></TaskShow>
      </div>
    </transition>
  </section>
</template>
<script>
import moment from "moment";
import TaskShow from "../../components/tasks/Show";
export default {
  components: {
    TaskShow,
  },
  data() {
    return {
      user: this.$route.params.user,
      tasks: this.$route.params.task,
      is_show: false,
      whichTaskIsLookedInShow: null,
      is_edit: false,
    };
  },
  methods: {
    showFunc(task) {
      this.whichTaskIsLookedInShow = task;
      this.is_show = true;
    },
    SetShowFunc(task) {
      this.showFunc(task);
    },
    async destroy() {
      const current_user = this.$store.getters["user/getCurrentUser"];
      if (this.user.id === current_user.id) {
        alert("自分で自分のアカウントを削除してはいけません");
        return;
      }
      const result = confirm(
        "本当にアカウントを消してもよろしいですか？（関連するタスクも全て消えます）"
      );
      if (result) {
        const url = "/api/user/admin/" + this.user.id;
        const token = this.$store.getters["auth/token"];
        this.axios.defaults.headers.common = {
          "X-Requested-With": "XMLHttpRequest",
          Authorization: "Token " + token,
        };
        const response = await this.axios.delete(url).catch((error) => {
          console.log(error);
          alert("エラーが起きました！");
        });
        if (response.status === 200) {
          alert("削除しました！");
          this.$router.push("/admin/dashboard");
        }
      }
    },
    async submit() {
      const user = {
        name: this.user.name,
        email: this.user.email,
        permission: this.user.permission,
        admin: this.user.admin,
      };
      const url = "/api/user/admin/" + this.user.id;
      const token = this.$store.getters["auth/token"];
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        Authorization: "Token " + token,
      };
      const response = await this.axios.patch(url, { user }).catch((error) => {
        console.log(error);
        alert("エラーが起きました！");
      });
      if (response.status === 200) {
        alert("更新しました！");
        this.$router.push("/admin/dashboard");
      }
    },
  },
  filters: {
    convert_time_format: function (value) {
      return moment(value).format("YYYY年 MM月DD日 HH:mm");
    },
    role(value) {
      return value ? "Admin" : "Nomal";
    },
    status(value) {
      return value ? "Approved" : "Banned";
    },
  },
};
</script>
<style lang="scss" scoped>
$border-color: black;
$delete-task-button-color: red;
$edit-task-button-color: #186de9;
$show-task-button-color: #186de9;
$yet: red;
$doing: yellow;
$done: #186de9;
$yet-color: white;
$doing-color: black;
$done-color: white;
$modal-background: rgba(0, 0, 0, 0.3);

#management-user-title {
  text-align: center;
}
#buttons {
  width: 80%;
  display: flex;
  flex-direction: row;
  justify-content: flex-end;
  align-items: center;
  margin: 10px 0;
  button {
    background-color: transparent;
    padding: 5px 10px;
    border: 1px solid black;
    margin: 0 10px;
    cursor: pointer;
    font-size: 1.3rem;
    border-radius: 10px;
    &:focus {
      outline: 0;
    }
  }
  #edit {
    background-color: $edit-task-button-color;
    color: white;
  }
  #delete {
    background-color: $delete-task-button-color;
    color: white;
  }
}
#user-infomation {
  width: 70%;
  margin: 30px auto 0 auto;
  h4 {
    width: 100%;
    margin: 20px 0;
    font-size: 1.3rem;
    .header {
      color: red;
    }
  }
  #introduction {
    padding: 10px;
    background-color: rgba(0, 0, 0, 0.1);
    margin-left: 30px;
  }
}
#edit-user-infomation {
  width: 70%;
  margin: 30px auto 0 auto;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  input[type="text"],
  input[type="email"] {
    width: 300px;
    margin: 10px 0;
    padding: 5px 10px;
  }
  .radio-container {
    margin: 10px 0 10px 20px;
    display: flex;
    flex-direction: row;
    justify-content: flex-start;
    align-items: center;
    div {
      margin-right: 20px;
    }
  }
  #edit-confirm {
    width: 100%;
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    button {
      padding: 5px 10px;
      background-color: transparent;
      color: black;
      border: 1px solid black;
      border-radius: 5px;
      cursor: pointer;
    }
  }
}
#this-user-task {
  margin-top: 40px;
  text-align: center;
}
.todo-card {
  width: 70%;
  padding: 10px 20px;
  border: 2px solid $border-color;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  position: relative;
  margin: 50px auto;
  .todo-created-at {
    position: absolute;
    top: -40px;
    left: 0;
    padding: 5px 10px;
    font-size: 1rem;
  }
  .task-title {
    font-size: 1.3rem;
  }
  .task-card-buttons {
    span {
      font-size: 1.4rem;
      display: inline-block;
      margin: 0 10px;
    }
    .status-marker {
      span {
        font-size: 1rem;
        display: inline-block;
        padding: 5px 10px;
        border-radius: 5px;
      }
      .yet {
        background-color: $yet;
        color: $yet-color;
      }
      .doing {
        background-color: $doing;
        color: $doing-color;
      }
      .done {
        background-color: $done;
        color: $done-color;
      }
    }
    .show-task-button {
      color: $show-task-button-color;
    }
    .edit-task-button {
      color: $edit-task-button-color;
    }
    .delete-task-button {
      color: $delete-task-button-color;
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
</style>
