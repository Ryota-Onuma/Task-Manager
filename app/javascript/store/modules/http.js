import axios from "axios";

export default {
  namespaced: true,
  actions: {
    async request({ dispatch, rootState }, { method, url, data, error }) {
      const headers = {};
      headers["Content-Type"] = "application/json";
      if (rootState.auth.token) {
        headers["Authorization"] = `Token ${rootState.auth.token}`;
        headers["User-Id"] = rootState.auth.userId;
      }

      const options = {
        method,
        url: `${url}`,
        headers,
        data,
        timeout: 15000,
      };

      return axios(options)
        .then((res) => res)
        .catch((err) => {
          if (
            JSON.parse(err.request.response)["errors"][0] ===
            "Email has already been taken"
          ) {
            alert("このメールアドレスは既に使われています。");
          } else {
            alert(JSON.parse(err.request.response)["errors"]);
          }
        });
    },
    async post({ dispatch }, requests) {
      requests.method = "post";
      return dispatch("request", requests);
    },
    async delete({ dispatch }, requests) {
      requests.method = "delete";
      return dispatch("request", requests);
    },
    async get({ dispatch }, requests) {
      requests.method = "get";
      return dispatch("request", requests);
    },
  },
};
