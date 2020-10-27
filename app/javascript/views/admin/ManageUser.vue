<template>
  <section id="manage-user">
    <div id="user-infomation">
      <h4>Name：{{ user.name }}</h4>
      <h4>Email:{{ user.email }}</h4>
      <h4>Permission:{{ user.permission }}></h4>
      <h4>Role: {{ user.admin }}</h4>
      <div id="introduction">
        {{ user.introduction }}
      </div>
    </div>
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
  },
  filters: {
    convert_time_format: function (value) {
      return moment(value).format("YYYY年 MM月DD日 HH:mm");
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

#manage-user {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  background-color: red;
  #user-infomation {
    width: 70%;
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
}
</style>
