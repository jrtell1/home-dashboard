<template>
  <div>
    <dashboard v-if="isLoggedIn"/>
    <login v-if="!isLoggedIn" @login="onLogin"/>
  </div>
</template>

<script>
import Login from './Login';
import Dashboard from './Dashboard';

export default {
  name: 'App',

  components: { Dashboard, Login },

  data() {
    return {
      isLoggedIn: false
    };
  },

  created() {
    if (process.browser) {
      const authToken = localStorage.getItem('authorization');

      this.isLoggedIn = !!authToken;
      this.$axios.setHeader('authorization', authToken);
    }
  },

  methods: {
    async onLogin(password) {
      try {
        const { data } = await this.$axios.post('/api/auth', { password });
        this.$axios.setHeader('authorization', data);
        localStorage.setItem('authorization', data);
        this.isLoggedIn = true;
      } catch (error) {
        console.error(error);
      }
    },
  }
};
</script>
