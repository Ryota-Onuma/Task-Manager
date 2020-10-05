<template>
  <section id="signup">
    <h1>Sign Up</h1>
    <div id="signup-form">
      <input type="text" placeholder="Enter your Name" v-model="name" />
      <input type="email" placeholder="Enter your Email" v-model="email" />
      <input
        type="password"
        placeholder="Enter your Password"
        v-model="password"
      />
      <input
        type="password"
        placeholder="Enter your Password Confirmation"
        v-model="password_confirm"
      />
      <div id="signup-post">
        <button>Sign Up</button>
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
        password: this.password,
      };
      this.$store.dispatch("auth/signup", {
        user,
      });
    },
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
  h1 {
    text-align: center;
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
    }
  }
}
</style>
