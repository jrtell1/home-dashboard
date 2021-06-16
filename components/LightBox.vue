<template>
  <div class="grid gap-4 grid-cols-3">
    <button
        v-if="light.on"
        class="flex col-span-2 items-center border border-gray-600 shadow-md rounded-md bg-gray-700 px-4 py-4 cursor-pointer select-none hover:bg-gray-600"
        @click="setLightOnState(false)"
    >
      <i class="fas fa-lightbulb fa-2x mr-2 text-yellow-100"></i>
      <span>{{ light.name }}</span>
    </button>
    <button
        v-if="!light.on"
        class="flex col-span-2 items-center border border-gray-600 shadow-md rounded-md bg-gray-700 px-4 py-4 cursor-pointer select-none hover:bg-gray-600"
        @click="setLightOnState(true)"
    >
      <i class="far fa-lightbulb fa-2x mr-2"></i>
      <span>{{ light.name }}</span>
    </button>

    <button
      class="flex items-center border border-gray-600 shadow-md rounded-md bg-gray-700 px-4 py-4 cursor-pointer select-none hover:bg-gray-600"
      @click="openModal(false)"
    >
      <i class="fas fa-sun"></i>
      <span class="whitespace-nowrap ml-1">{{ Math.round((brightness / 255) * 100) }}<span class="ml-1">%</span></span>
    </button>

    <modal :name="'brightness-'+light.name" :adaptive="true" height="auto">
      <div class="p-10 bg-gray-800 shadow-lg">
        <h3>Ljusstyrka - {{ light.name }}</h3>
        <div class="flex flex-col justify-center">
          <div class="flex items-center">
            <vue-slider
              class="flex-1"
              direction="ltr"
              tooltip="none"
              :dotSize="20"
              :min="0"
              :max="255"
              v-model="brightness"
              @drag-end="setLightBrightnessState"
            ></vue-slider>
            <div class="ml-1">{{ ((brightness / 255) * 100).toFixed(0) }} <span class="text-gray-400">%</span></div>
          </div>
          <slot></slot>
        </div>
      </div>
    </modal>
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
    openModal() {
      this.$modal.show('brightness-'+this.light.name);
    },

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
