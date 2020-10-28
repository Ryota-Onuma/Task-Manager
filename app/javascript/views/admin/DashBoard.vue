<template>
  <section id="dashboard">
    <h1 id="admin-title">Manage Users</h1>
    <table>
      <tr id="table-header">
        <th>ID</th>
        <td>Name</td>
        <td>Email</td>
        <td>Role</td>
      </tr>
      <tr>
        <th>見出し</th>
        <td>データ</td>
        <td>データ</td>
        <td>データ</td>
      </tr>
      <tr>
        <th>見出し</th>
        <td>データ</td>
        <td>データ</td>
        <td>データ</td>
      </tr>
      <tr>
        <th>見出し</th>
        <td>データ</td>
        <td>データ</td>
        <td>データ</td>
      </tr>
      <tr>
        <th>見出し</th>
        <td>データ</td>
        <td>データ</td>
        <td>データ</td>
      </tr>
    </table>
  </section>
</template>

<script>
export default {
  data() {
    return {
      title: "dashboardです",
    };
  },
  created() {
    const current_user = this.$store.getters["user/getCurrentUser"];
    if (!current_user.admin) {
      //adminユーザーじゃなかったら突き返す
      this.$router.push("/");
    }
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
