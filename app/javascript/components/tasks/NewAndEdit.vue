<template>
  <section id="task-new-and-edit">
    <div id='task-new-and-edit-close-container'> <!-- closeボタン -->
      <span id='task-new-and-edit-close' @click="close()">×</span>
    </div>
    <div id='task-new-and-edit-white-box'> <!-- new-and-editの白いBox -->
        <h1 id="task-new-and-edit-title" v-if='is_new'>New Task</h1>
        <h1 id="task-new-and-edit-title" v-else>Edit Task</h1>
        <div id='todo-info-container'>
          <input type='text' placeholder="Enter your task title" id="task-form-title" class='task-form-parts' v-model="inputTask.title">
          <textarea placeholder="Enter your task content" id='task-form-content' class='task-form-parts' v-model="inputTask.content"></textarea>
        </div>
        <div id='task-submit-container'>
          <span id='submit' @click="submit()">
            Submit
          </span>
        </div>
    </div>
  </section>
</template>
<script>
export default {
  props:{
    task: Object,
    is_new_and_edit: Boolean,
    is_new: Boolean
  },
  data(){
    return{
      inputTask: {
        title:'',
        content:'',
        status:1,
        deadline:'',
        important:false
      }
    }
  },
  watch:{
    task:function(task){
      this.inputTask = task
    }
  },

  methods:{
    close(){
      this.$emit('update:is_new_and_edit', false); 
    },
    submit(){
      let url;
      const inputTask = this.inputTask
      if (is_new === true){  //新規登録の場合
         url = '/api/tasks'
          this.axios
            .post(url,{
              inputTask
            })
            .then(response => {
              alert('新規投稿が完了しました！')
              this.$emit('update:is_new_and_edit', false); 
            })
            .catch(error => {
                console.log(error);
                alert('エラーが起きました！')
            });
      }else{　//更新の場合
        url = '/api/tasks/' + this.task.id  
         this.axios
            .patch(url,{
               inputTask
            })
            .then(response => {
              alert('更新が完了しました！')
              this.$emit('update:is_new_and_edit', false); 
            })
            .catch(error => {
                console.log(error);
                alert('エラーが起きました！')
            });
      }
    }
  }
}
</script>
<style lang="scss" scoped>
$background-color:white;
$close-button-color:white;
  @media only screen and (max-width: 1365px) {}
  @media screen and (min-width: 1366px) {
    #task-new-and-edit{
      width: 100%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      #task-new-and-edit-close-container{
        display: flex;
        flex-direction: row;
        justify-content: flex-end;
        align-items: center;
        width: 90%;
        margin: 0 auto 30px auto;
        #task-new-and-edit-close{
          font-size: 4rem;
          color: $close-button-color;
          cursor: pointer;
        }
      }
      #task-new-and-edit-white-box{
        width: 80%;
        background-color: $background-color;
        padding: 50px 100px;
       #task-new-and-edit-title{
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
          .task-form-parts{
            margin: 10px;
            font-size: 1.4rem;
            padding: 5px;
          }
          #task-form-title{
            width: 80%;
          }
          #task-form-content{
            width: 100%;
          }
        }
        #task-submit-container{
          display: flex;
          flex-direction: row;
          justify-content: flex-end;
          width: 100%;
          padding: 50px 50px 0 0;
          box-sizing: border-box;
          #submit{
            font-size: 1.4rem;
            cursor: pointer;
          }
        }
        }
    }
  }

</style>