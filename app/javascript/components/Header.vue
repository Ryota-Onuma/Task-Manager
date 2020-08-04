<template>
  <header>
    <div id="product-title">
      <span>Task-Manager</span>
    </div>
    <div id="links">
      <router-link to="/">Your Tasks</router-link>
      <router-link to="/about">About</router-link>
    </div>
  </header>
</template>
<script>
export default {
  data() {
    return {};
  },
};
</script>
<style lang="scss" scoped>
$background-color: white;
$link-color: #186de9;
@media only screen and (max-width: 1365px) {
}
@media screen and (min-width: 1366px) {
  header {
    width: 100%;
    height: 80px;
    background-color: $background-color;
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    padding: 0 100px;
    box-sizing: border-box;
    box-shadow: 0 0 30px 0 rgba(0, 0, 0, 0.2);
    margin-bottom: 50px;
    #product-title {
      span {
        font-size: 2rem;
        color: $link-color;
      }
    }
    #links {
      a {
        display: inline-block;
        margin: 0 20px;
        color: $link-color;
        text-decoration: none;
      }
    }
  }
}
</style>
