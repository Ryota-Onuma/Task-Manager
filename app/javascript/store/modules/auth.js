export default {
  namespaced: true,
  state: {
    userId: "",
    token: "",
  },
  mutations: {
    create(state, data) {
      state.token = data.token;
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
        .catch((err) => err);
    },
    signup({ commit, dispatch }, data) {
      dispatch(
        "http/post",
        { url: "/api/auth/signup", data, error: "message.unauthorized" },
        { root: true }
      )
        .then((res) => commit("create", res.data))
        .catch((err) => err);
    },
    signout({ commit, dispatch }, data) {
      commit("destroy");
      dispatch("user/deleteCurrentUserAction");
      localStorage.clear();
    },
  },
};
