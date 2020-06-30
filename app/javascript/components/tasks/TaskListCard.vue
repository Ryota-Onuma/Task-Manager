<template>
  <div class='todo-card'>
    <span class='task-title'>{{ task.title }}</span>
    <div class='task-card-buttons'>
      <span class="show-task-button" @click='SetShowFunc(task)'><i class="fas fa-info-circle"></i></span>
      <span class="edit-task-button" @click="SetEditFunc(task)"><i class="fas fa-edit"></i></span>
      <span class="delete-task-button"><i class="fas fa-trash"></i></span>
    </div>
  </div>
</template>
<script>
export default {
  props:{
    task: Object,
    showFunc: Function,
    editFunc: Function
  },
  methods:{
 
    SetShowFunc(task){
      this.showFunc(task)
    },
    SetEditFunc(task){
      this.editFunc(task)
    },
  }
}
</script>
<style lang="scss" scoped>
  $border-color:black;
  $delete-task-button-color:red;
  $edit-task-button-color:#186de9;
  $show-task-button-color:#186de9;
  @media only screen and (max-width: 1365px) {

  }
  @media screen and (min-width: 1366px) {
    .todo-card{
      width: 100&;
      padding: 10px 20px;
      border: 2px solid $border-color;
      display: flex;
      flex-direction: row;
      justify-content: space-between;
      .task-title{
        font-size: 1.3rem;
      }
      .task-card-buttons{
       span{
         font-size: 1.4rem;
         display: inline-block;
         margin: 0 10px;
       }
       .show-task-button{
         color:$show-task-button-color
         
       }
       .edit-task-button{
         color: $edit-task-button-color;
       }
       .delete-task-button{
         color: $delete-task-button-color;
       }
      }
   }
  }
</style>