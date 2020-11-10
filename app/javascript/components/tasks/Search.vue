<template>
  <div id="todo-search">
    <h1>タスク検索</h1>
    <div id="search-forms-container">
      <h3 class="search-headline">Title</h3>
      <input type="text" v-model="query.title_cont" placeholder="タイトルを入力" />
      <h3 class="search-headline">Status</h3>
      <div id="status-container" class="label-box">
        <input v-model="query.status_eq" type="radio" id="yet" value="1" />
        <label for="yet">Yet</label>
        <input id="doing" v-model="query.status_eq" type="radio" value="2" />
        <label for="doing">Doing</label>
        <input id="done" v-model="query.status_eq" type="radio" value="3" />
        <label for="done">Done</label>
        <input id="no" v-model="query.status_eq" type="radio" value />
        <label for="no">No Specification</label>
      </div>
      <h3 class="search-headline">Priority</h3>
      <div id="important-container" class="label-box">
        <input v-model="query.important_eq" type="radio" id="high" value="1" />
        <label for="high">High</label>
        <input id="mid" v-model="query.important_eq" type="radio" value="2" />
        <label for="mid">Middle</label>
        <input id="low" v-model="query.important_eq" type="radio" value="3" />
        <label for="low">Low</label>
        <input id="no2" v-model="query.important_eq" type="radio" value />
        <label for="no2">No Specification</label>
      </div>
      <h3 class="search-headline">Tag</h3>
      <div id="tag-container" class="label-box">
        <div v-for="tag in tags" :key="tag.id" class="tag">
          <input v-model="tag_id" type="radio" :id="'tag-' + tag.id " :value="tag.id" />
          <label :for="'tag-' + tag.id ">{{ tag.title }}</label>
        </div>
      </div>
      <div id="search-button-container">
        <button @click="search">Search</button>
      </div>
    </div>
  </div>
</template>
<script>
import Qs from "qs";
export default {
  props: {
    tasks: Array,
    tags: Array,
    is_search: Boolean,
  },
  data() {
    return {
      query: {
        title_cont: null,
        status_eq: "",
        important_eq: "",
      },
      tag_id: null,
    };
  },
  methods: {
    search() {
      const token = this.$store.getters["auth/token"];
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        Authorization: "Token " + token,
      };
      const url = "/api/task/search";
      this.axios
        .get(url, {
          params: {
            q: this.query,
            tag_id: this.tag_id
          },
          paramsSerializer: function (params) {
            return Qs.stringify(params, { arrayFormat: "brackets" });
          },
        })
        .then((response) => {
          if (response.data.tasks.length > 0) {
            this.$emit("update:tasks", response.data.tasks);
            this.$emit("update:is_search", false);
          } else {
            alert("検索条件に当てはまるタスクが見つかりませんでした");
          }
        })
        .catch((error) => {
          this.rescue(error)
        });
    },
  },
};
</script>
<style lang="scss" scoped>
$yet: red;
$doing: yellow;
$done: #186de9;
$yet-color: white;
$doing-color: black;
$done-color: white;
#todo-search {
  width: 100vw;
  min-height: 80vh;
  background: white;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  h1 {
    text-align: center;
  }
  #search-forms-container {
    width: 60%;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    margin: 50px;
    .search-headline {
      margin: 10px;
    }
    #tag-container {
      display: flex;
      flex-direction: row;
      justify-content: flex-start;
      flex-wrap: wrap;
      .tag {
        min-width: 300px;
        input[type="radio"]:checked + label {
          background-color: red;
          color: white;
        }
      }
    }
    input[type="text"] {
      width: 60%;
      padding: 5px 10px;
      margin: 20px 10px;
    }

    .label-box {
      display: flex;
      flex-direction: row;
      input[type="radio"] {
        display: none;
        + label {
          margin: 0 20px;
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
      #no + label {
        border: 1px solid black;
        color: black;
      }
      #no:checked + label {
        background-color: black;
        color: white;
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
      #high + label {
        border: 1px solid $yet;
        color: $yet;
      }
      #mid + label {
        border: 1px solid $doing;
        color: black;
      }
      #low + label {
        border: 1px solid $done;
        color: $done;
      }
      #no2 + label {
        border: 1px solid black;
        color: black;
      }
      #no2:checked + label {
        background-color: black;
        color: white;
      }
      #high:checked + label {
        background-color: $yet;
        color: $yet-color;
      }
      #mid:checked + label {
        background-color: $doing;
        color: $doing-color;
      }
      #low:checked + label {
        background-color: $done;
        color: $done-color;
      }
    }
    #search-button-container {
      width: 100%;
      display: flex;
      flex-direction: row;
      justify-content: flex-end;
      padding-right: 100px;
      box-sizing: border-box;
      margin-top: 40px;
      button {
        padding: 5px 10px;
        background-color: transparent;
        border-radius: 5px;
        box-shadow: none;
        cursor: pointer;
        font-size: 1.3rem;
        &:hover {
          background: rgba(0, 0, 0, 0.1);
        }
      }
    }
  }
}
</style>
