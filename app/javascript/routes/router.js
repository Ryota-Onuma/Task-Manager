import Vue from "vue";
import Router from "vue-router";
Vue.use(Router);
import About from "../views/About.vue";
import TaskIndex from "../views/tasks/Index.vue"
import TaskShow from "../views/tasks/Show.vue"
const router = new Router({
  mode: "history",
  routes: [
    //ルーティングの設定
    {
      path: "/",
      component: TaskIndex,
    },
    {
      path:"/tasks/index",
      component: TaskIndex,
    },
    {
      path: "/task/:id",
      component: TaskShow
    },
    {
      path: "/about",
      component: About,
    },

  ],
});
export default router;