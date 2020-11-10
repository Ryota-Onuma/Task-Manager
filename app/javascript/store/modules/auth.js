import router from "../../routes/router.js";
import errors from "../../mixins/errors/error";
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
    async signin({ commit, dispatch }, data) {
      try {
        const res = await dispatch(
          "http/post",
          { url: "/api/auth/signin", data, error: "message.unauthorized" },
          { root: true }
        );
        if (res) {
          commit("create", res.data);
        }
      } catch (error) {
        errors.methods.rescue(error);
      }
    },
    async signup({ commit, dispatch }, data) {
      try {
        const res = await dispatch(
          "http/post",
          { url: "/api/auth/signup", data, error: "message.unauthorized" },
          { root: true }
        );
        commit("create", res.data);
        dispatch("setToken");
      } catch (error) {
        errors.methods.rescue(error);
      }
    },
    async signout({ commit, dispatch }) {
      try {
        commit("destroy");
        await dispatch("user/deleteCurrentUserAction", null, { root: true });
        router.push("/signin");
      } catch (error) {
        errors.methods.rescue(error);
      }
    },
    async setToken({ commit, dispatch }) {
      try {
        const res = await dispatch(
          "http/get",
          { url: "/api/auth/get_token", error: "no token" },
          { root: true }
        );
        if (res.data) {
          commit("create", res.data);
          dispatch("user/setCurrentUserAction", null, { root: true });
        }
      } catch (error) {
        errors.methods.rescue(error);
      }
    },
  },
};
