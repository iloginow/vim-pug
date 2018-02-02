<template lang="pug">
div.test
  p.someparagraph {{ message }}
  div#special(v-bind="smth")
  img(:src='../some/file.jpg' @click='fancystuff' data="smth")
  router-link(to="bar") Go to bar
</template>

<script>
import SomeComponent from '../compoments/SomeComponent'
export default {
  components: {
    SomeComponent
  },
  data () {
    return {
      message: "That's a message"
    }
  }
}
</script>

<style lang="stylus">
.test
  display block
    p
      text-align center
</style>
