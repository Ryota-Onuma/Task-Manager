<template>
  <header v-if="isSignedIn">
    <div id="product-title">
      <span>Task-Manager</span>
    </div>
    <div id="links">
      <router-link to="/">Your Tasks</router-link>
      <router-link to="/admin/dashboard" v-if="is_admin">Admin</router-link>
      <button type="button" @click="signOut">Sign Out</button>
    </div>
  </header>
</template>
<script>
export default {
  data() {
    return {};
  },

  methods: {
    signOut() {
      const result = confirm("本当にログアウトしてもよろしいですか？？");
      if (result) {
        const url = "/api/auth/signout";
        this.axios
          .delete(url)
          .then((response) => {
            this.$store.dispatch("auth/signout");
          })
          .catch((error) => {
            console.log(error);
            alert("エラーが起きました！");
          });
      }
    },
  },
  computed: {
    isSignedIn() {
      if (
        this.$route.path.indexOf("signin") !== -1 ||
        this.$route.path.indexOf("signup") !== -1
      ) {
        return false;
      } else {
        return true;
      }
    },
    is_admin() {
      const current_user = this.$store.getters["user/getCurrentUser"];
      return current_user.admin;
    },
  },
};
</script>
<style lang="scss" scoped>
$link-color: #186de9;
@media only screen and (max-width: 1365px) {
}
@media screen and (min-width: 1366px) {
  header {
    width: 100%;
    height: 80px;
    background-color: white;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 0 100px;
    box-sizing: border-box;
    box-shadow: 0 0 30px 0 rgba(0, 0, 0, 0.2);
    margin-bottom: 50px;
    #product-title {
      span {
        font-size: 2rem;
        color: $link-color;
      }
    }
    #links {
      a {
        display: inline-block;
        margin: 0 20px;
        color: $link-color;
        text-decoration: none;
        font-size: 1rem;
      }
      button {
        display: inline-block;
        margin: 0 20px;
        color: red;
        border: 0;
        background-color: white;
        font-size: 1rem;
        cursor: pointer;
        &:focus {
          outline: 0;
        }
      }
    }
  }
}
</style>
