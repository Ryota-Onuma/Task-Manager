<template>
  <section id="dashboard">
    <h1 id="admin-title">Manage Users</h1>
    <div id="add-user">
      <button @click="is_new = !is_new">Add User</button>
    </div>
    <table>
      <tr id="table-header">
        <th>ID</th>
        <td>Name</td>
        <td>Tasks</td>
        <td>Email</td>
        <td>Role</td>
        <td>Action</td>
      </tr>
      <tr v-for="(user_task, index) in users_tasks" :key="index">
        <td>{{ user_task.user.id }}</td>
        <td>{{ user_task.user.name }}</td>
        <td>{{ user_task.tasks.length }}</td>
        <td>{{ user_task.user.email }}</td>
        <td>{{ user_task.user.admin | role }}</td>
        <td>
          <router-link
            :to="{
              name: 'manage_user',
              params: {
                id: user_task.user.id,
                user: user_task.user,
                task: user_task.tasks,
              },
            }"
            >管理</router-link
          >
        </td>
      </tr>
    </table>
    <div id="new-user-form" v-show="is_new">
      <div id="new-form">
        <div id="close">
          <span @click="is_new = !is_new">×</span>
        </div>
        <h3>新規ユーザー作成</h3>
        <div>
          <label for="name">Name：</label>
          <input type="text" id="name" v-model="name" placeholder="Name" />
        </div>
        <div>
          <label for="email">Email：</label>
          <input type="email" id="email" v-model="email" placeholder="Email" />
        </div>
        <div>
          <label for="password">Password：</label>
          <input
            type="password"
            id="password"
            v-model="password"
            placeholder="Password"
          />
        </div>
        <div>
          <label for="password_confirm">Password Confirm：</label>
          <input
            type="password"
            id="password_confirm"
            v-model="password_confirm"
            placeholder="Password Confirm"
          />
        </div>
        <div>Permission</div>
        <div class="radio-container">
          <div>
            <label>
              <input type="radio" v-model="permission" :value="true" />
              Approve
            </label>
          </div>
          <div>
            <label>
              <input type="radio" v-model="permission" :value="false" />
              Ban
            </label>
          </div>
        </div>
        <div>Admin</div>
        <div class="radio-container">
          <div>
            <label>
              <input type="radio" v-model="admin" :value="true" />Admin
            </label>
          </div>
          <div>
            <label>
              <input type="radio" v-model="admin" :value="false" />Nomal
            </label>
          </div>
        </div>
        <div id="new-post">
          <button @click="addUser()">Post</button>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  data() {
    return {
      title: "dashboardです",
      users_tasks: null,
      is_new: false,
      name: "",
      email: "",
      password: "",
      password_confirm: "",
      permission: false,
      admin: false,
    };
  },
  created() {
    const current_user = this.$store.getters["user/getCurrentUser"];
    if (!current_user.admin) {
      //adminユーザーじゃなかったら突き返す
      this.$router.push("/");
    }
    this.getUsersAndTasks();
  },
  methods: {
    async getUsersAndTasks() {
      const url = "/api/user/admin";
      const token = this.$store.getters["auth/token"];
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        Authorization: "Token " + token,
      };
      const response = await this.axios.get(url).catch((error) => {
        console.log(error);
        alert("エラーが起きました！");
      });
      this.users_tasks = null;
      this.users_tasks = response.data.users_tasks;
    },
    async addUser() {
      if (this.email === "" || this.email === null) {
        alert("Emailが入力されていません");
        return;
      }
      if (this.password === "" || this.password === null) {
        alert("Passewordが入力されていません");
        return;
      }
      if (this.password_confirm === "" || this.password_confirm === null) {
        alert("確認Passewordが入力されていません");
        return;
      }
      if (this.password !== this.password_confirm) {
        alert("Passewordが一致しません");
        return;
      }
      const user = {
        name: this.name,
        email: this.email,
        password_digest: this.password,
        permission: this.permission,
        admin: this.admin,
      };
      const url = "/api/user/admin";
      const token = this.$store.getters["auth/token"];
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        Authorization: "Token " + token,
      };
      const response = await this.axios.post(url, { user }).catch((error) => {
        console.log(error.response.data.error);
        alert("エラーが起きました！");
        this.is_new = false;
      });
      if (response && response.status === 200) {
        alert("ユーザーを作成しました");
        this.getUsersAndTasks();
        this.is_new = false;
      }
    },
  },

  filters: {
    role(value) {
      return value ? "Admin" : "Nomal";
    },
  },
};
</script>

<style lang="scss" scoped>
$table-header-color: #77a5f2;
#dashboard {
  display: flex;
  flex-direction: column;
  align-items: center;
  #admin-title {
    font-size: 1.8rem;
    text-align: center;
    margin-bottom: 40px;
  }
  #add-user {
    width: 80%;
    display: flex;
    flex-direction: row;
    justify-content: flex-end;
    margin: 20px 0;
    button {
      padding: 10px 20px;
      background-color: transparent;
      cursor: pointer;
    }
  }
  table {
    width: 80%;
    border-collapse: collapse;
    border-spacing: 0;
  }

  table th,
  table td {
    padding: 10px 0;
    text-align: center;
    a {
      text-decoration: none;
    }
  }
  #table-header {
    background-color: $table-header-color;
    color: white;
  }
  table tr:nth-child(odd) {
    background-color: #eee;
  }
  #new-user-form {
    width: 100vw;
    height: 100vh;
    position: absolute;
    top: 0;
    right: 0;
    left: 0;
    margin: auto;
    z-index: 3;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    #new-form {
      width: 60%;
      display: flex;
      flex-direction: column;
      background-color: white;
      padding: 30px;
      box-shadow: 0 0 30px 0 rgba(0, 0, 0, 0.3);
      h3 {
        text-align: center;
      }
      #close {
        width: 100%;
        display: flex;
        flex-direction: row;
        justify-content: flex-end;
        span {
          font-size: 3rem;
          cursor: pointer;
        }
      }
      input {
        margin: 20px 0;
        padding: 5px 10px;
      }
      .radio-container {
        display: flex;
        flex-direction: row;
        justify-content: flex-start;
        padding-left: 20px;
        labeL {
          margin-right: 10px;
        }
      }
      #new-post {
        display: flex;
        flex-direction: row;
        justify-content: flex-end;
        button {
          padding: 10px 20px;
          background-color: transparent;
          cursor: pointer;
        }
      }
    }
  }
}
</style>
