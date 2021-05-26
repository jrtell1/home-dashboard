<template>
  <div>
    <div class="text-8xl font-mono mb-2">{{ time }}</div>
    <time class="text-gray-400">{{ date }}</time>
  </div>
</template>

<script>
import dayjs from 'dayjs';

export default {
  name: 'Clock',

  data() {
    return {
      time: '',
      date: ''
    };
  },

  created() {
    this.time = this.getCurrentTime();
    this.date = this.getCurrentDate();

    setInterval(() => {
      this.time = this.getCurrentTime();
      this.date = this.getCurrentDate();
    }, 1000);
  },

  methods: {
    getCurrentTime() {
      return dayjs().format('HH:mm');
    },
    getCurrentDate() {
      return dayjs().format('LL');
    }
  }
};
</script>
