<template>
  <box :title="title">
    <h1 class="text-6xl pb-4">
      {{ value }}<small class="text-gray-400 ml-1">{{ unit }}</small>
    </h1>
    <slot></slot>
  </box>
</template>

<script>
import Box from './Box';

export default {
  name: 'DataBox',

  components: { Box },

  props: {
    title: {
      required: true
    },
    value: {
      required: true
    },
    unit: {
      required: false
    }
  }
};
</script>
