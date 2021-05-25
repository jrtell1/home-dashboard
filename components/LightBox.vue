<template>
  <div class="grid gap-4 grid-cols-2">
    <div
        v-if="light.on"
        class="flex flex-col justify-center items-center border border-gray-600 shadow-md rounded-md bg-gray-700 py-4 cursor-pointer select-none hover:bg-gray-600"
        @click="setLightOnState(false)"
    >
      <i class="fas fa-lightbulb fa-3x mb-4 text-yellow-100"></i>
      <h2>På</h2>
    </div>
    <div
        v-else
        class="flex flex-col justify-center items-center border border-gray-600 shadow-md rounded-md bg-gray-700 py-4 cursor-pointer select-none hover:bg-gray-600"
        @click="setLightOnState(true)"
    >
      <i class="far fa-lightbulb fa-3x mb-4"></i>
      <h2>Av</h2>
    </div>
    <div class="flex flex-col items-center">
      <div>{{ ((brightness / 255) * 100).toFixed(0) }} <span class="text-gray-400">%</span></div>
      <vue-slider
          class="flex-1"
          direction="btt"
          tooltip="none"
          :dotSize="20"
          :min="0"
          :max="255"
          v-model="brightness"
          @drag-end="setLightBrightnessState"
      ></vue-slider>
      <h2 class="text-sm pt-1 text-gray-300">Ljusstyrka</h2>
    </div>
    <slot></slot>
  </div>
</template>

<script>
import Box from './Box';
import VueSlider from 'vue-slider-component/dist-css/vue-slider-component.umd.min.js';
import 'vue-slider-component/dist-css/vue-slider-component.css';
import 'vue-slider-component/theme/default.css';

export default {
  name: 'LightBox',

  components: { Box, VueSlider },

  props: {
    light: {
      required: true
    }
  },

  data() {
    return {
      brightness: 0
    };
  },

  created() {
    this.brightness = this.light.brightness;
  },

  methods: {
    async setLightOnState(on) {
      try {
        const { data } = await this.$axios.post('/api/home/lights/' + this.light.id, { on });
        this.$emit('updated');
      } catch (error) {
        console.error(error);
        this.error = error;
      }
    },

    async setLightBrightnessState() {
      try {
        const { data } = await this.$axios.post('/api/home/lights/' + this.light.id, {
          brightness: this.brightness
        });
        this.$emit('updated');
      } catch (error) {
        console.error(error);
        this.error = error;
      }
    },
  }
};
</script>
