<template>
  <div id="app">
    <Header></Header>
    <router-view></router-view>
  </div>
</template>

<script>
import Header from "./components/Header.vue";
export default {
  components: {
    Header,
  },
  created() {
    const token = this.$store.getters["auth/token"];
    if (token) {
      this.axios.defaults.headers.common = {
        "X-Requested-With": "XMLHttpRequest",
        Authorization: "Token " + token,
      };
      this.axios
        .post("/api/auth/current_user")
        .then((response) => {
          const currentUser = {
            id: response.data.id,
            name: response.data.name,
            email: response.data.email,
          };
          this.$store.dispatch("user/setCurrentUserAction", currentUser);
        })
        .catch((error) => {
          console.log(error);
        });
    }
  },
};
</script>

<style scoped></style>
