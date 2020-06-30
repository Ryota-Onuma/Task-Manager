<template>
  <section id="task-show">
    <div id='task-show-close-container'> <!-- closeボタン -->
      <span id='task-show-close' @click="close()">×</span>
    </div>
    <div id='task-show-white-box'> <!-- showの白いBox -->
        <h1 id="task-show-title">Task Info</h1>
        <div id='todo-info-container'>
          <div id="task-id" class='task-info-parts'>id：{{task.id}}</div>
          <div id="task-title" class='task-info-parts'>Title：{{ task.title}}</div>
          <div id='assigned-user' class='task-info-parts'>Assignee:{{ user.name}} </div>
          <div id='task-content' class='task-info-parts'>Content:{{ task.content }}</div>
        </div>
    </div>
  </section>
</template>
<script>
export default {
  props:{
    task: Object,
    user:Object,
    is_show: Boolean
  },
  methods:{
    close(){
      this.$emit('update:is_show', false); 
    }
  }
}
</script>
<style lang="scss" scoped>
$background-color:white;
$close-button-color:white;
  @media only screen and (max-width: 1365px) {}
  @media screen and (min-width: 1366px) {
    #task-show{
      width: 100%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      #task-show-close-container{
        display: flex;
        flex-direction: row;
        justify-content: flex-end;
        align-items: center;
        width: 90%;
        margin: 0 auto 30px auto;
        #task-show-close{
          font-size: 4rem;
          color: $close-button-color;
          cursor: pointer;
        }
      }
      #task-show-white-box{
        width: 80%;
        background-color: $background-color;
        padding: 50px 100px;
       #task-show-title{
          font-size: 1.8rem;
          color:resd;
          text-align: center;
        }
        #todo-info-container{
          width: 80%;
          margin: 50px auto 0 auto;
          display: flex;
          flex-direction: column;
          align-items: flex-start;
          justify-content: center;
          .task-info-parts{
            margin: 10px;
            font-size: 1.4rem;
          }
        }
        }
    }
  }

</style>