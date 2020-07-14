<template>
  <section id="task-new-and-edit">
    <div id='task-new-and-edit-close-container'> <!-- closeボタン -->
      <span id='task-new-and-edit-close' @click="close()">×</span>
    </div>
    <div id='task-new-and-edit-white-box'> <!-- new-and-editの白いBox -->
        <h1 id="task-new-and-edit-title" v-if='is_new'>New Task</h1>
        <h1 id="task-new-and-edit-title" v-else>Edit Task</h1>
        <div id='todo-info-container'>
          <div id='todo-status-container'>
              
              <input type="radio" id="yet" value="1" v-model="inputTask.status">
              <label for="yet">Yet</label>


              <input type="radio" id="doing" value="2" v-model="inputTask.status">
              <label for="doing">Doing</label>

              <input type="radio" id="done" value="3" v-model="inputTask.status">
              <label for="done">Done</label>
          </div>
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
    refreshTasksAllData:Function,
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
      this.axios.defaults.headers.common = {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      };
      if (inputTask.title === ''){
        alert('タスクのタイトルが入力されていません。')
        return
      }
      if(inputTask.content === ''){
        alert('タスク内容が入力されていません。')
        return
      }
      if (this.is_new === true){  //新規登録の場合
         url = '/api/tasks'
          this.axios
            .post(url,{
              inputTask
            })
            .then(response => {
              this.refreshTasksAllData(response.data)
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
              this.refreshTasksAllData(response.data)
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
$background-color: white;
$close-button-color: white;
$label-background-color: #186de9;
$label-font-color: white;
$yet: red;
$doing: yellow;
$done: #186de9;
$yet-color: white;
$doing-color: black;
$done-color: white;
@media only screen and (max-width: 1365px) {
}
@media screen and (min-width: 1366px) {
    #task-new-and-edit {
        width: 100%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        #task-new-and-edit-close-container {
            display: flex;
            flex-direction: row;
            justify-content: flex-end;
            align-items: center;
            width: 90%;
            margin: 0 auto 30px auto;
            #task-new-and-edit-close {
                font-size: 4rem;
                color: $close-button-color;
                cursor: pointer;
            }
        }
        #task-new-and-edit-white-box {
            width: 80%;
            background-color: $background-color;
            padding: 50px 100px;
            #task-new-and-edit-title {
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

                .task-form-parts {
                    margin: 10px;
                    font-size: 1.4rem;
                    padding: 5px;
                }
                #task-form-title {
                    width: 80%;
                }
                #task-form-content {
                    width: 100%;
                    min-height: 300px;
                }
                #todo-status-container {
                    width: 100%;
                    display: flex;
                    flex-direction: row;
                    justify-content: flex-end;
                    align-items: center;
                    box-sizing: border-box;
                    padding: 30px 50px;
                    input[type='radio'] {
                        display: none;
                        + label {
                            margin: 0 10px;
                            display: inline-block;
                            padding: 5px 10px;
                            font-size: 1.2rem;
                            cursor: pointer;
                        }
                        &:checked + label {
                            display: inline-block;
                        }
                    }
                    #yet + label {
                        border: 1px solid $yet;
                        color: $yet;
                    }
                    #doing + label {
                        border: 1px solid $doing;
                        color: black;
                    }
                    #done + label {
                        border: 1px solid $done;
                        color: $done;
                    }
                    #yet:checked + label {
                        background-color: $yet;
                        color: $yet-color;
                    }
                    #doing:checked + label {
                        background-color: $doing;
                        color: $doing-color;
                    }
                    #done:checked + label {
                        background-color: $done;
                        color: $done-color;
                    }
                }
            }
            #task-submit-container {
                display: flex;
                flex-direction: row;
                justify-content: flex-end;
                width: 100%;
                padding: 50px 50px 0 0;
                box-sizing: border-box;
                #submit {
                    font-size: 1.4rem;
                    cursor: pointer;
                }
            }
        }
    }
}
</style>
