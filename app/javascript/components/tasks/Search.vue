<template>
  <div id="todo-search">
    <h1>検索</h1>
    <div id="search-forms-container">
      <input type="text" v-model="query.title" placeholder="タイトルを入力" />
      <div id="status-container">
        <input v-model="query.status" type="radio" id="yet" value="1" />
        <label for="yet">Yet</label>
        <input id="doing" v-model="query.status" type="radio" value="2" />
        <label for="doing">Doing</label>
        <input id="done" v-model="query.status" type="radio" value="3" />
        <label for="done">Done</label>
      </div>
      <button @click="search">Search</button>
    </div>
  </div>
</template>
<script>
import Qs from "qs";
export default {
  props: {
    tasks: Array,
  },
  data() {
    return {
      query: {
        title: null,
        status: 1,
        important: false,
      },
    };
  },
  methods: {
    search() {
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        "X-CSRF-TOKEN": document
          .querySelector('meta[name="csrf-token"]')
          .getAttribute("content"),
      };
      const url = "/api/task/search";
      this.axios
        .get(url, {
          params: {
            q: this.query,
          },
          paramsSerializer: function (params) {
            return Qs.stringify(params, { arrayFormat: "brackets" });
          },
        })
        .then((response) => {
          console.log(response.data);
          this.$emit("update:tasks", response.data.tasks);
        })
        .catch((error) => {
          console.dir(error);
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
    input[type="text"] {
      padding: 5px 10px;
      margin: 20px 10px;
    }

    #status-container {
      display: flex;
      flex-direction: row;
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
    }
  }
}
</style>
