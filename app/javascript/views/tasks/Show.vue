<template>
  <section id="task-show">
    <h1 id="task-show-title">Task Info</h1>
    <div id='todo-info-container'>
      <div id="task-id" class='task-info-parts'>id：{{task.id}}</div>
      <div id="task-title" class='task-info-parts'>Title：{{ task.title}}</div>
      <div id='assigned-user' class='task-info-parts'>Assignee:{{ user.name}} </div>
      <div id='task-content' class='task-info-parts'>Content:{{ task.content }}</div>
    </div>
  </section>
</template>
<script>
export default {
  data(){
    return{
      task:null,
      user: null
    }
  },
  created(){
    this.getTask()
  },
  methods:{
    getTask(){
     const url = "/api/tasks/" + this.$route.params.id;
     this.axios
      .get(url)
      .then(response => {
       this.task = response.data.task
       this.user = response.data.user
      })
      .catch(error => {
        console.log(error);
        alert('エラーが起きました！')
      });
    }
  }
}
</script>
<style lang="scss" scoped>
  @media only screen and (max-width: 1365px) {}
  @media screen and (min-width: 1366px) {
    #task-show{
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

</style>