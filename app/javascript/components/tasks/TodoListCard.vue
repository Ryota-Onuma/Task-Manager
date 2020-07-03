<template>
  <div class='todo-card'>
    <span class='task-title'>{{ task.title }}</span>
  </div>
</template>
<script>
export default {
  props:{
    task: Object
  }
}
</script>
<style lang="scss" scoped>
  $border-color:black;
  @media only screen and (max-width: 1365px) {

  }
  @media screen and (min-width: 1366px) {
    .todo-card{
      width: 100&;
      padding: 10px 20px;
      border: 2px solid $border-color;
      .task-title{
        font-size: 1.3rem;
      }
   }
  }
</style>