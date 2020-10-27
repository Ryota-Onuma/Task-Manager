<template>
  <section id="signin">
    <h1>Sign In</h1>
    <div id="signin-form">
      <input type="email" placeholder="Enter your Email" v-model="email" />
      <input
        type="password"
        placeholder="Enter your Password"
        v-model="password"
      />
      <div id="signin-post">
        <button @click="signIn">Sign In</button>
      </div>
      <div id="go-here-who-has-no-account">
        <router-link to="/signup"
          >アカウントをお持ちでない方はこちら</router-link
        >
      </div>
    </div>
  </section>
</template>
<script>
export default {
  data() {
    return {
      email: null,
      password: null,
    };
  },
  methods: {
    signIn() {
      if (this.email === "" || this.email === null) {
        alert("メールアドレスを入力してください");
        return;
      }
      if (this.password === "" || this.password === null) {
        alert("パスワードを入力してください");
        return;
      }
      const user = {
        email: this.email,
        password: this.password,
      };
      this.$store.dispatch("auth/signin", {
        user,
      });
    },
  },
  mounted() {
    if (this.$store.getters["auth/token"]) {
      //もしすでにlocalstrage にトークンがあったらトップページに飛ばす
      this.$router.push("/");
    }
    this.$store.watch(
      (state, getters) => getters["auth/token"],
      (newValue, oldValue) => {
        const token = this.$store.getters["auth/token"];
        if (token) {
          this.$store.dispatch("user/setCurrentUserAction");
        }
      }
    );
  },
};
</script>
<style lang="scss" scoped>
#signin {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  h1 {
    text-align: center;
    margin-top: 200px;
  }
  #signin-form {
    width: 50%;
    padding: 30px;
    input {
      width: 100%;
      padding: 5px 10px;
      margin: 10px;
    }
    #signin-post {
      width: 100%;
      display: flex;
      flex-direction: row;
      justify-content: flex-end;
      padding-right: 40px;
      box-sizing: border-box;
      button {
        padding: 10px;
        background-color: white;
        border: 0;
        font-size: 1.1rem;
        margin: 30px 0;
        cursor: pointer;
        &:hover {
          background-color: rgba(skyblue, 0.2);
        }
      }
    }
    #go-here-who-has-no-account {
      display: flex;
      flex-direction: row;
      justify-content: flex-end;
      a {
        font-size: 0.7rem;
      }
    }
  }
}
</style>
