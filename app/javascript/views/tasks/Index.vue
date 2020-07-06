<template>
    <section id="tasks-index">
        <h1 id='tasks-index-title'>Your Tasks</h1>
        <div id="tasks-container" v-if="tasks">
            <router-link :to="'/task/' + task.id" v-for='(task,index) in tasks' :key="index" class="each-todo">
                <TaskListCard :task='task'></TaskListCard>
            </router-link>
        </div>
    </section>
</template>
<script>
import TaskListCard from '../../components/tasks/TodoListCard'
export default {
    components:{
        TaskListCard 
    },
    data(){
        return{
            tasks: null
        }
    },
    created(){
        this.getTodos()
    },
    methods:{
        getTodos(){
            const url = "/api/tasks";
            this.axios
            .get(url)
            .then(response => {
            this.tasks = response.data
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
  $link-color: #186de9;
    a{
        text-decoration: none;
        color: $link-color;
    }
  @media only screen and (max-width: 1365px) {}
  @media screen and (min-width: 1366px) {
      #tasks-index{
          #tasks-index-title{
              font-size: 1.8rem;
              color:resd;
              text-align: center;
          }
          #tasks-container{
              display: flex;
              flex-direction: column;
              align-items: center;
              margin-top:50px;
            .each-todo{
                width: 70%;
                margin: 20px 0;
                cursor: pointer;
                transition: all .5s;
                &:hover {
                 transform: scale(1.02,1.02);
              }

            }

          }
      }
  }
</style>