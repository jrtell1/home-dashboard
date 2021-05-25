<template>
  <div class="bg-gray-800 shadow-lg overflow-hidden">
    <div class="p-4">
      <h2 class="font-semibold text-gray-400 mb-2">{{ title }}</h2>
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Box',

  props: {
    title: {
      required: true
    },
  }
};
</script>
