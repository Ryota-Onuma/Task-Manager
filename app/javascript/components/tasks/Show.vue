<template>
  <section id="task-show">
    <div id="task-show-close-container">
      <!-- closeボタン -->
      <span id="task-show-close" @click="close()">×</span>
    </div>
    <div id="task-show-white-box">
      <!-- showの白いBox -->
      <h1 id="task-show-title">Task Info</h1>

      <div id="todo-info-container">
        <div id="task-id" class="task-info-parts">id：&ensp;{{ task.id }}</div>
        <div id="task-title" class="task-info-parts">
          Title：&ensp;{{ task.title }}
        </div>
        <div class="status-marker task-info-parts">
          Status：&ensp;
          <span v-if="task.status === 1" class="yet">Yet</span>
          <span v-else-if="task.status === 2" class="doing">Doing</span>
          <span v-else-if="task.status === 3" class="done">Done</span>
        </div>
        <div class="status-marker task-info-parts">
          Priority ：&ensp;
          <span v-if="task.important === 1" class="yet">High</span>
          <span v-else-if="task.important === 2" class="doing">Middle</span>
          <span v-else-if="task.important === 3" class="done">Log</span>
        </div>
        <div id="assigned-user" class="task-info-parts">
          Assignee:&ensp;{{ user.name }}
        </div>
        <div id="task-content" class="task-info-parts">Content</div>
        <div id="task-content-box">
          {{ task.content }}
        </div>
      </div>
    </div>
  </section>
</template>
<script>
export default {
  props: {
    task: Object,
    user: Object,
    is_show: Boolean,
  },
  methods: {
    close() {
      this.$emit("update:is_show", false);
    },
  },
};
</script>
<style lang="scss" scoped>
$background-color: white;
$close-button-color: white;
$yet: red;
$doing: yellow;
$done: #186de9;
$yet-color: white;
$doing-color: black;
$done-color: white;
@media only screen and (max-width: 1365px) {
}
@media screen and (min-width: 1366px) {
  #task-show {
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    #task-show-close-container {
      display: flex;
      flex-direction: row;
      justify-content: flex-end;
      align-items: center;
      width: 90%;
      margin: 0 auto 30px auto;
      #task-show-close {
        font-size: 4rem;
        color: $close-button-color;
        cursor: pointer;
      }
    }
    #task-show-white-box {
      width: 80%;
      background-color: $background-color;
      padding: 50px 100px;
      #task-show-title {
        font-size: 1.8rem;
        color: resd;
        text-align: center;
      }

      #todo-info-container {
        width: 80%;
        margin: 50px auto 0 auto;
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        justify-content: center;
        .status-marker {
          width: 80%;
          display: flex;
          flex-direction: row;
          justify-content: flex-start;
          align-items: center;
          span {
            font-size: 1.4rem;
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
        .task-info-parts {
          margin: 10px;
          font-size: 1.4rem;
        }
        #task-content-box {
          width: 80%;
          padding: 10px 10px 10px 20px;
          box-sizing: border-box;
        }
      }
    }
  }
}
</style>
