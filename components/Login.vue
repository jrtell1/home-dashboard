<template>
  <div class="text-white bg-gray-900 min-h-screen">
    <h1 class="pt-2 px-4 text-gray-400 font-semibold font-mono">Mastermind</h1>
    <div class="flex items-center justify-center">
      <form class="py-32 flex flex-col items-center justify-center max-w-md" @submit.prevent="login">
        <input
            class="mt-1 py-1 px-2 shadow-md bg-gray-800 rounded text-white focus:outline-none focus:ring transition w-full"
            type="password"
            placeholder="Lösenord"
            v-model="password"
        >
        <button
            class="mt-3 py-1 px-2 text-gray-300 shadow-md bg-gray-700 hover:bg-gray-800 rounded text-white focus:outline-none focus:ring transition w-full"
            type="submit"
        >
          Execute
        </button>
      </form>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Login',

  data() {
    return {
      password: ''
    }
  },

  methods: {
    login() {
      this.$emit('login', this.password);
    }
  }
};
</script>
