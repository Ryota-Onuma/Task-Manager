<template>
  <section id="signup">
    <h1>Sign Up</h1>
    <div id="signup-form">
      <input type="text" placeholder="Enter your Name" v-model="name" />
      <input type="email" placeholder="Enter your Email" v-model="email" />
      <input type="password" placeholder="Enter your Password" v-model="password" />
      <input
        type="password"
        placeholder="Enter your Password Confirmation"
        v-model="password_confirm"
      />
      <div id="signup-post">
        <button @click="signUp">Sign Up</button>
      </div>
      <div id="go-here-who-already-has-account">
        <router-link to="/signin">既にアカウントをお持ちの方はこちら</router-link>
      </div>
    </div>
  </section>
</template>
<script>
export default {
  data() {
    return {
      name: null,
      email: null,
      password: null,
      password_confirm: null,
    };
  },
  methods: {
    signUp() {
      if (this.email === "" || this.email === null) {
        alert("メールアドレスを入力してください");
        return;
      }
      if (this.password === "" || this.password === null) {
        alert("パスワードを入力してください");
        return;
      }
      if (this.password !== this.password_confirm) {
        alert("パスワードと確認パスワードが一致しません");
        return;
      }
      const user = {
        name: this.name,
        email: this.email,
        password_digest: this.password,
      };
      this.$store.dispatch("auth/signup", {
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
          this.$router.push("/")
        }
      }
    );
  },
};
</script>
<style lang="scss" scoped>
#signup {
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
  #signup-form {
    width: 50%;
    padding: 30px;
    input {
      width: 100%;
      padding: 5px 10px;
      margin: 10px;
    }
    #signup-post {
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
    #go-here-who-already-has-account {
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
