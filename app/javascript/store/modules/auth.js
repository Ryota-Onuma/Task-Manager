import router from "../../routes/router.js";
export default {
  namespaced: true,
  state: {
    userId: "",
    token: "",
  },
  mutations: {
    create(state, data) {
      state.token = data;
    },
    destroy(state) {
      state.token = "";
    },
  },
  getters: {
    token(state) {
      return state.token;
    },
  },
  actions: {
    signin({ commit, dispatch }, data) {
      dispatch(
        "http/post",
        { url: "/api/auth/signin", data, error: "message.unauthorized" },
        { root: true }
      )
        .then((res) => commit("create", res.data))
        .catch((error) => {
          console.dir(error);
          if (error.response.status === 500) {
            this.$router.push("/500error");
          } else {
            alert("エラーが発生しました！");
          }
        });
    },
    signup({ commit, dispatch }, data) {
      dispatch(
        "http/post",
        { url: "/api/auth/signup", data, error: "message.unauthorized" },
        { root: true }
      )
        .then((res) => {
          commit("create", res.data);
          dispatch("setToken");
        })
        .catch((error) => {
          console.dir(error);
          if (error.response.status === 500) {
            router.push("/500error");
          } else {
            alert("エラーが発生しました！");
          }
        });
    },
    signout({ commit, dispatch }) {
      commit("destroy");
      dispatch("user/deleteCurrentUserAction", null, { root: true });
      router.push("/signin");
    },
    setToken({ commit, dispatch }) {
      dispatch(
        "http/get",
        { url: "/api/auth/get_token", error: "no token" },
        { root: true }
      )
        .then((res) => {
          if (res.data) {
            commit("create", res.data);
            dispatch("user/setCurrentUserAction", null, { root: true });
          }
        })
        .catch((err) => {
          console.dir(error);
          if (error.response.status === 500) {
            router.push("/500error");
          } else {
            alert("エラーが発生しました！");
          }
        });
    },
  },
};
