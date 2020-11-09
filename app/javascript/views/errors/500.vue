<template>
  <section id="error-500">
    <div id="error-500-body">
      <h1>500</h1>
      <h2>お探しのページは見つかりません</h2>
    </div>
  </section>
</template>
<script>
export default {
  
}
</script>
<style lang="scss" scoped>
#error-500 {
  width: 100%;
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  #error-500-body {
    width: 80%;
    height: 40vh;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
    align-items: center;
    h1 {
      text-align: center;
      font-size: 3rem;
    }
    h2 {
      text-align: center;
      font-size: 2rem;
    }
  }
}
</style>