import router from "../../routes/router.js";
export default {
  namespaced: true,
  state: {
    currentUser: {
      id: null,
      name: null,
      email: null,
      admin: null,
    },
  },
  mutations: {
    setCurrentUser(state, payload) {
      state.currentUser.id = payload.id;
      state.currentUser.name = payload.name;
      state.currentUser.email = payload.email;
      state.currentUser.admin = payload.admin;
    },
    deleteCurrentUser(state) {
      state.currentUser.id = null;
      state.currentUser.name = null;
      state.currentUser.email = null;
      state.currentUser.admin = null;
    },
  },
  getters: {
    getCurrentUser(state) {
      if (
        state.currentUser.id &&
        state.currentUser.name &&
        state.currentUser.email
      ) {
        return state.currentUser;
      } else {
        return false;
      }
    },
  },
  actions: {
    setCurrentUserAction({ commit, dispatch }) {
      dispatch(
        "http/get",
        { url: "/api/auth/current_user", error: "no user" },
        { root: true }
      )
        .then((res) => {
          commit("setCurrentUser", {
            id: res.data.id,
            name: res.data.name,
            email: res.data.email,
            admin: res.data.admin,
          });
        })
        .catch((err) => console.log(err));
    },
    deleteCurrentUserAction(context) {
      context.commit("deleteCurrentUser");
    },
  },
};
