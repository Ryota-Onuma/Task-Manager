export default {
  namespaced: true,
  state: {
    currentUser: {
      id: null,
      name: null,
      email: null,
    },
  },
  mutations: {
    setCurrentUser(state, payload) {
      state.currentUser.id = payload.id;
      state.currentUser.name = payload.name;
      state.currentUser.email = payload.email;
    },
    deleteCurrentUser(state) {
      state.currentUser.id = null;
      state.currentUser.name = null;
      state.currentUser.email = null;
    },
  },
  getters: {
    getCurrentUser(state) {
      return state.currentUser;
    },
  },
  actions: {
    setCurrentUserAction(context, payload) {
      context.commit("setCurrentUser", {
        id: payload.id,
        name: payload.name,
        email: payload.email,
      });
    },
    deleteCurrentUserAction(content) {
      content.commit("deleteCurrentUser");
    },
  },
};