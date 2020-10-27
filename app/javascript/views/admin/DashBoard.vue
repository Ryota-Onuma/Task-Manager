<template>
  <section id="dashboard">
    <h1 id="admin-title">Manage Users</h1>
    <table>
      <tr id="table-header">
        <th>ID</th>
        <td>Name</td>
        <td>Email</td>
        <td>Role</td>
        <td>Action</td>
      </tr>
      <tr v-for="(user_task, index) in users_tasks" :key="index">
        <td>{{ user_task.user.id }}</td>
        <td>{{ user_task.user.name }}</td>
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
  </section>
</template>

<script>
export default {
  data() {
    return {
      title: "dashboardです",
      users_tasks: null,
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
      this.users_tasks = response.data.users_tasks;
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
}
</style>
