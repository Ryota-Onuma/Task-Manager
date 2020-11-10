import router from "../../routes/router";
export default {
  methods: {
    rescue(error) {
      try {
        console.dir(error);
        if (error.response.status === 500) {
          router.push("/500error");
        } else {
          alert("エラーが発生しました！");
        }
      } catch (err) {
        console.dir(err);
      }
    },
  },
};
