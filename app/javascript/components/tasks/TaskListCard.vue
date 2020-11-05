<template>
  <div class="todo-card">
    <span class="todo-created-at">
      <span style="background: red; color: white; padding: 5px;">〆</span>
      {{ task.deadline | convert_time_format }}
    </span>
    <span class="task-title">{{ task.title }}</span>
    <div class="task-card-buttons">
      <span class="tag">{{ tag(task.tag_id )}}</span>
      <span class="status-marker">
        <span v-if="task.status === 1" class="yet">Yet</span>
        <span v-else-if="task.status === 2" class="doing">Doing</span>
        <span v-else-if="task.status === 3" class="done">Done</span>
      </span>
      <span class="status-marker">
        <span v-if="task.important === 1" class="yet">Priority High</span>
        <span v-else-if="task.important === 2" class="doing">Priority Middle</span>
        <span v-else-if="task.important === 3" class="done">Priority Low</span>
      </span>
      <span class="show-task-button" @click="SetShowFunc(task)">
        <i class="fas fa-info-circle"></i>
      </span>
      <span class="edit-task-button" @click="SetEditFunc(task)">
        <i class="fas fa-edit"></i>
      </span>
      <span class="delete-task-button" @click="Destroy()">
        <i class="fas fa-trash"></i>
      </span>
    </div>
  </div>
</template>
<script>
import moment from "moment";
export default {
  props: {
    task: Object,
    showFunc: Function,
    editFunc: Function,
    refreshTasksAllData: Function,
  },
  methods: {
    SetShowFunc(task) {
      this.showFunc(task);
    },
    SetEditFunc(task) {
      this.editFunc(task);
    },
    Destroy() {
      const result = window.confirm("本当に削除してもよろしいですか？？");
      if (result === false) {
        return;
      }
      const url = "/api/tasks/" + this.task.id;
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-TOKEN": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      };
      this.axios
        .delete(url)
        .then((response) => {
          this.refreshTasksAllData(response.data);
          alert("削除が完了しました！");
        })
        .catch((error) => {
          console.log(error);
          alert("エラーが起きました！");
        });
    },
  },
  computed: {
    tag() {
      return function(tag_id) {
        this.tags.forEach(tag => {
          if (tag.id === tag_id){
            return tag.title
          }
        })
      }
    }
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
@media only screen and (max-width: 1365px) {
}
@media screen and (min-width: 1366px) {
  .todo-card {
    width: 100&;
    padding: 10px 20px;
    border: 2px solid $border-color;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    position: relative;
    margin: 20px 0;
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
}
</style>
