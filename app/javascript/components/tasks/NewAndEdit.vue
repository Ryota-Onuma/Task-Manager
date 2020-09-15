<template>
  <section id="task-new-and-edit">
    <div id="task-new-and-edit-close-container">
      <!-- closeボタン -->
      <span id="task-new-and-edit-close" @click="close()">×</span>
    </div>
    <div id="task-new-and-edit-white-box">
      <!-- new-and-editの白いBox -->
      <h1 v-if="is_new" id="task-new-and-edit-title">New Task</h1>
      <h1 v-else id="task-new-and-edit-title">Edit Task</h1>
      <div id="todo-info-container">
        <div id="todo-status-container">
          <transition name="fade">
            <div id="datepicker-calender-container" v-show="datepicker">
              <div id="datepicker-calender-container-top">
                <div id="close-container">
                  <span @click="datepicker = false">×</span>
                </div>
                <h1>日付を選択</h1>
                <h3 v-if="deadline_date">
                  終了期限：&ensp;&ensp;
                  {{ deadline_date | dateFormant }}&ensp;&ensp;{{ stringTime }}
                </h3>
                <h3 v-else>日付と時間を選択してください</h3>
              </div>
              <div id="pickers">
                <div class="picker">
                  <h4>日付を選択</h4>
                  <Datepicker
                    :language="ja"
                    :format="DatePickerFormat"
                    v-model="deadline_date"
                    placeholder="日付を選択してください"
                    id="datepicker"
                    :inline="true"
                  ></Datepicker>
                </div>
                <div class="picker">
                  <h4>時間を選択</h4>
                  <Timepicker
                    id="timepicker"
                    :format="format"
                    :minute-interval="minInterval"
                    placeholder="時間"
                    hour-label="時"
                    minute-label="分"
                    v-model="stringTime"
                  />
                </div>
              </div>
              <div id="deadline-confirm">
                <span @click="datepicker = false">確定</span>
              </div>
            </div>
          </transition>
          <div id="deadline-button-container">
            <h3 v-if="deadline_date && stringTime">
              終了期限：&ensp;&ensp;
              {{ deadline_date | dateFormant }}&ensp;&ensp;{{ stringTime }}
            </h3>
            <button @click="datepicker = true">{{ isDateSelected() }}</button>
          </div>
          <input v-model="inputTask.status" type="radio" id="yet" value="1" />
          <label for="yet">Yet</label>
          <input id="doing" v-model="inputTask.status" type="radio" value="2" />
          <label for="doing">Doing</label>
          <input id="done" v-model="inputTask.status" type="radio" value="3" />
          <label for="done">Done</label>
        </div>
        <datepicker :format="DatePickerFormat" :language="ja" placeholder="日付を選択してください"></datepicker>
        <input
          id="task-form-title"
          v-model="inputTask.title"
          type="text"
          placeholder="Enter your task title"
          class="task-form-parts"
        />
        <textarea
          id="task-form-content"
          v-model="inputTask.content"
          placeholder="Enter your task content"
          class="task-form-parts"
        ></textarea>
      </div>
      <div id="task-submit-container">
        <span id="submit" @click="submit()">Submit</span>
      </div>
    </div>
  </section>
</template>
<script>
import Datepicker from "vuejs-datepicker";
import VueTimepicker from "vue2-timepicker";
import "vue2-timepicker/dist/VueTimepicker.css";
import { ja } from "vuejs-datepicker/dist/locale";
import moment from "moment";

export default {
  components: {
    Datepicker,
    Timepicker: VueTimepicker,
  },
  props: {
    task: Object,
    refreshTasksAllData: Function,
    is_new_and_edit: Boolean,
    is_new: Boolean,
  },
  components: {
    Datepicker
  },
  data() {
    return {
      inputTask: {
        title: "",
        content: "",
        status: 1,
        deadline: null,
        important: false,
      },
      format: "HH:mm", // 形式 AMなどの指定もできる
      minInterval: 5,
      stringTime: "15:00",
      deadline_date: null,
      datepicker: false,
      DatePickerFormat: "yyyy年 M/d",
      ja: ja,
    };
  },
  watch: {
    task: function (task) {
      this.inputTask = task;
      if (this.inputTask.deadline) {
        this.deadline_date = this.inputTask.deadline;
        this.stringTime = moment(this.inputTask.deadline).format("HH:mm");
      }
    },
  },

  methods: {
    close() {
      this.stringTime = "";
      this.deadline_date = null;
      this.$emit("update:is_new_and_edit", false);
    },
    submit() {
      let url;
      const inputTask = this.inputTask;
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-TOKEN": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      };
      if (inputTask.title === "") {
        alert("タスクのタイトルが入力されていません。");
        return;
      }
      if (inputTask.content === "") {
        alert("タスク内容が入力されていません。");
        return;
      }
      if (this.deadline_date === null || this.stringTime === "") {
        alert("終了期限が追加されていません");
        return;
      } else {
        const deadline = moment(this.deadline_date);
        const stringTime = this.stringTime;
        const hh = Number(stringTime.slice(0, 2));
        const mm = Number(stringTime.slice(-2));
        deadline.set("hour", hh);
        deadline.set("minute", mm);
        this.inputTask.deadline = deadline;
      }
      if (this.is_new === true) {
        //新規登録の場合
        url = "/api/tasks";
        this.axios
          .post(url, {
            inputTask,
          })
          .then((response) => {
            this.refreshTasksAllData(response.data);
            alert("新規投稿が完了しました！");
            this.stringTime = "";
            this.deadline_date = null;
            this.$emit("update:is_new_and_edit", false);
          })
          .catch((error) => {
            console.dir(error);
            alert(
              error.response.data.error.replace(
                "バリデーションに失敗しました:",
                ""
              )
            );
          });
      } else {
        //更新の場合
        url = "/api/tasks/" + this.task.id;
        this.axios
          .patch(url, {
            inputTask,
          })
          .then((response) => {
            this.refreshTasksAllData(response.data);
            alert("更新が完了しました！");
            this.stringTime = "";
            this.deadline_date = null;
            this.$emit("update:is_new_and_edit", false);
          })
          .catch((error) => {
            console.dir(error);
            alert(
              error.response.data.error.replace(
                "バリデーションに失敗しました:",
                ""
              )
            );
          });
      }
    },
    isDateSelected() {
      return this.deadline_date && this.stringTime
        ? "終了期限を変更"
        : "終了期限を設定";
    },
  },
  filters: {
    dateFormant(value) {
      return moment(value).format("YYYY年MM月DD日");
    },
  },
};
</script>
<style lang="scss" scoped>
@import "../../assets/stylesheets/application.scss";
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
    @include flex-column(center, center);
    #task-new-and-edit-close-container {
      @include flex-row(flex-end, center);
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
        @include flex-column(flex-start, center);
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
          @include flex-row(flex-end, center);
          box-sizing: border-box;
          padding: 30px 50px;
          input[type="radio"] {
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
          #deadline-button-container {
            @include flex-row(flex-end, center);
            width: 70%;
            padding-right: 100px;

            button {
              background-color: transparent;
              border: 1px solid black;
              padding: 5px 10px;
              cursor: pointer;
              margin-left: 50px;
            }
          }
          #datepicker-calender-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100vh;
            background-color: rgba(0, 0, 0, 0.7);
            @include flex-column(center, center);
            padding-bottom: 200px;
            box-sizing: border-box;
            #datepicker-calender-container-top {
              width: 70%;
              @include flex-column(center, center);
              h1 {
                text-align: center;
                font-size: 2rem;
                color: white;
                margin: 50px 0;
              }
              h3 {
                text-align: center;
                color: white;
                margin: 50px 0;
                font-weight: thin;
              }
              #close-container {
                width: 100%;
                @include flex-row(flex-end, center);
                span {
                  font-size: 4rem;
                  color: white;
                  cursor: pointer;
                }
              }
            }
            #pickers {
              width: 60%;
              @include flex-row(space-around, flex-start);
              .picker {
                @include flex-column(center, center);
                h4 {
                  color: white;
                  margin: 20px;
                }
              }
            }
            #deadline-confirm {
              width: 60%;
              @include flex-row(flex-end, center);
              span {
                font-size: 1.6rem;
                color: white;
                cursor: pointer;
              }
            }
          }
        }
      }
      #task-submit-container {
        @include flex-row(flex-end, center);
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
