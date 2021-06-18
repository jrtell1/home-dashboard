<template>
  <div class="text-white bg-gray-900 min-h-screen relative">
    <h1 class="px-4 text-gray-400 font-semibold font-mono text-xs leading-tight -mb-3">
      Hemma
      <span class="font-normal text-xs">| uppdaterat {{ lastApiCallAt }}</span>
    </h1>
    <div class="grid gap-4 sm:grid-cols-2 sm:grid-rows-4 lg:grid-cols-3 lg:grid-rows-3 xl:grid-cols-4 p-4">
      <data-box title="Temperatur - Vardagsrum" :value="(livingroomTemperatureSensor.value / 100).toFixed(1)" unit="°C">
        <div class="text-xs text-gray-500 mb-4">
          {{ fromNow(livingroomTemperatureSensor.sensor_updated_at) }}
        </div>
        <div class="grid gap-4 grid-cols-2">
          <div v-for="sensor in temperatureSensors">
            <div class="text-xs text-gray-300">
              {{ sensor.name }}
            </div>
            <div class="text-xl">{{ (sensor.value / 100).toFixed(1) }}<span class="text-gray-400 text-base ml-1">°C</span></div>
            <div class="text-xs text-gray-500">
              {{ fromNow(sensor.sensor_updated_at) }}
            </div>
          </div>
        </div>
      </data-box>

<!--      <data-box title="Lufttryck" :value="airPressureAverage.toFixed(0)" unit="hPa">-->
<!--        <div class="grid gap-4 grid-cols-3">-->
<!--          <div v-for="sensor in airPressureSensors">-->
<!--            <div class="text-xs text-gray-300">-->
<!--              {{ sensor.name }}-->
<!--            </div>-->
<!--            <div class="text-xl">{{ sensor.value.toFixed(0) }} <span class="text-gray-400 text-base">hPa</span></div>-->
<!--            <div class="text-xs text-gray-500">-->
<!--              {{ fromNow(sensor.sensor_updated_at) }}-->
<!--            </div>-->
<!--          </div>-->
<!--        </div>-->
<!--      </data-box>-->

      <box title="Väder" class="row-span-full">
        <div class="divide-y divide-gray-600">
          <div class="py-1" v-for="hourlyForecast in forecast">
            <div class="text-xs text-gray-400 capitalize">
              <strong>{{ isSameHour(hourlyForecast.at) ? 'Nu - ' : '' }}</strong>
              {{ forecastDate(hourlyForecast.at) }}
            </div>
            <div class="grid grid-cols-5 gap-1">
              <div class="text-sm font-semibold leading-tight flex col-span-2">
                <div class="mr-1 w-6 flex justify-center mt-2">
                  <i :class="'fas fa-lg ' + getWeatherIcon(hourlyForecast.weather_symbol)"></i>
                </div>
                <div class="whitespace-nowrap">
                  <span :class="{'text-xs': hourlyForecast.weather.length > 15}">{{ hourlyForecast.weather }}</span>
                  <div class="text-xs font-normal text-gray-400">
                    <span class="mr-1" v-if="hourlyForecast.precipitation_category > 0">
                      <i class="fas fa-xs fa-cloud-rain"></i>
                      {{ hourlyForecast.precipitation }}
                    </span>
                    <span v-if="hourlyForecast.thunder_probability > 0">
                      <i class="fas fa-xs fa-bolt text-blue-300"></i>
                      {{ hourlyForecast.thunder_probability }}%
                    </span>
                  </div>
                </div>
              </div>
              <div class="text-sm flex flex-col justify-center">
                <div class="text-xs text-gray-400">Temp</div>
                <span>
                  {{ parseFloat(hourlyForecast.air_temperature).toFixed(1) }}
                  <span class="text-gray-400 text-xs">°C</span>
                </span>
              </div>
              <div class="text-sm flex flex-col justify-center">
                <div class="text-xs text-gray-400">Vind</div>
                <span>
                  {{ parseFloat(hourlyForecast.wind_speed).toFixed(1) }}
                  <span class="text-gray-400 text-xs">m/s</span>
                </span>
              </div>
              <div class="text-sm flex flex-col justify-center">
                <div class="text-xs text-gray-400">Nederbörd</div>
                <span class="whitespace-nowrap">
                  {{ parseFloat(hourlyForecast.precipitation_mean_intensity).toFixed(1) }}
  <!--                {{ hourlyForecast.horizontal_visibility }}-->
                  <span class="text-gray-400 text-xs">mm/h</span>
                </span>
              </div>
            </div>
          </div>
        </div>
      </box>

      <data-box title="Luftfuktighet - Vardagsrum" :value="(livingroomHumiditySensor.value / 100).toFixed(0)" unit="%">
        <div class="text-xs text-gray-500 mb-4">
          {{ fromNow(livingroomHumiditySensor.sensor_updated_at) }}
        </div>
        <div class="grid gap-4 grid-cols-2">
          <div v-for="sensor in humiditySensors">
            <div class="text-xs text-gray-300">
              {{ sensor.name }}
            </div>
            <div class="text-xl">{{ (sensor.value / 100).toFixed(0) }}<span class="text-gray-400 text-base ml-1">%</span></div>
            <div class="text-xs text-gray-500">
              {{ fromNow(sensor.sensor_updated_at) }}
            </div>
          </div>
        </div>
      </data-box>

      <box title="Lampor" class="row-span-2">
        <div class="grid gap-4">
          <light-box
            v-if="livingRoomLight"
            :light="livingRoomLight"
            @updated="this.getLightsData"
          >
            <div class="text-xs text-gray-500">
              {{ fromNow(livingRoomLight.last_seen_at) }}
            </div>
          </light-box>
          <light-box
            v-if="windowLight"
            :light="windowLight"
            @updated="this.getLightsData"
          >
            <div class="text-xs text-gray-500">
              {{ fromNow(windowLight.last_seen_at) }}
            </div>
          </light-box>
          <light-box
            v-if="deskLight"
            :light="deskLight"
            @updated="this.getLightsData"
          >
            <div class="text-xs text-gray-500">
              {{ fromNow(deskLight.last_seen_at) }}
            </div>
          </light-box>
        </div>
      </box>

      <box title="Klocka">
        <clock></clock>
      </box>
    </div>
  </div>
</template>

<script>
import DataBox from './DataBox';
import Box from './Box';
import LightBox from './LightBox';
import Clock from './Clock';

export default {
  name: 'Dashboard',

  components: { Clock, LightBox, Box, DataBox },

  data() {
    return {
      sensors: [],
      lights: [],
      forecast: [],
      lastApiCallAt: null
    }
  },

  computed: {
    temperatureSensors() {
      return this.sensors.filter(sensor => sensor.type === 'ZHATemperature' && sensor.name !== 'Vardagsrum');
    },
    airPressureSensors() {
      return this.sensors.filter(sensor => sensor.type === 'ZHAPressure');
    },
    humiditySensors() {
      return this.sensors.filter(sensor => sensor.type === 'ZHAHumidity' && sensor.name !== 'Vardagsrum');
    },
    livingroomTemperatureSensor() {
      const sensors = this.sensors.filter(sensor => sensor.type === 'ZHATemperature' && sensor.name === 'Vardagsrum');

      return sensors.length ? sensors[0] : {};
    },
    livingroomHumiditySensor() {
      const sensors = this.sensors.filter(sensor => sensor.type === 'ZHAHumidity' && sensor.name === 'Vardagsrum');

      return sensors.length ? sensors[0] : {};
    },
    // temperatureAverage() {
    //   const sum = this.temperatureSensors.reduce((accumulated, sensor) => accumulated + sensor.value, 0);
    //   const avg = (sum / this.temperatureSensors.length) || 0;
    //
    //   return avg;
    // },
    // airPressureAverage() {
    //   const sum = this.airPressureSensors.reduce((accumulated, sensor) => accumulated + sensor.value, 0);
    //   const avg = (sum / this.airPressureSensors.length) || 0;
    //
    //   return avg;
    // },
    humidityAverage() {
      const sum = this.humiditySensors.reduce((accumulated, sensor) => accumulated + sensor.value, 0);
      const avg = (sum / this.humiditySensors.length) || 0;

      return avg;
    },
    livingRoomLight() {
      const light = this.lights.filter(light => light.name.toLowerCase() === 'vardagsrum')[0];

      return light || null;
    },
    windowLight() {
      const light = this.lights.filter(light => light.name.toLowerCase() === 'fönster 1')[0];

      return light || null;
    },
    deskLight() {
      const light = this.lights.filter(light => light.name.toLowerCase() === 'skrivbord')[0];

      return light || null;
    }
  },

  created() {
    this.getSensorsData();
    this.getLightsData();
    this.getForecastData();

    setInterval(() => {
      this.getSensorsData();
      this.getLightsData();
      this.getForecastData();
    }, 60 * 1000);
  },

  methods: {
    async getSensorsData() {
      try {
        const { data } = await this.$axios.get('/api/home/sensors');
        this.sensors = data;
        this.updateApiLastCalledAt();
      } catch (error) {
        console.error(error);
        this.error = error;
      }
    },

    async getLightsData() {
      try {
        const { data } = await this.$axios.get('/api/home/lights');
        this.lights = data;
        this.updateApiLastCalledAt();
      } catch (error) {
        console.error(error);
        this.error = error;
      }
    },

    async getForecastData() {
      try {
        const { data } = await this.$axios.get('/api/weather/forecast');
        this.forecast = data;
        this.updateApiLastCalledAt();
      } catch (error) {
        console.error(error);
        this.error = error;
      }
    },

    updateApiLastCalledAt() {
      this.lastApiCallAt = this.$dayjs().fromNow();
    },

    fromNow(date) {
      return this.$dayjs(date).fromNow(true) + ' sedan';
    },

    forecastDate(date) {
      // return this.$dayjs(date).format('HH:mm, MMM DD');
      return this.$dayjs(date).calendar(null, {
        sameDay: '[Idag] HH:mm', // The same day ( Today at 2:30 AM )
        nextDay: '[Imorgon] HH:mm', // The next day ( Tomorrow at 2:30 AM )
        nextWeek: 'dddd', // The next week ( Sunday at 2:30 AM )
        lastDay: '[Igår] HH:mm', // The day before ( Yesterday at 2:30 AM )
        lastWeek: '[Förra] dddd', // Last week ( Last Monday at 2:30 AM )
        sameElse: 'YYYY-MM-DD HH:mm' // Everything else ( 7/10/2011 )
      });
    },

    isSameHour(date) {
      return this.$dayjs().isSame(date, 'hour');
    },

    getWeatherIcon(symbol) {
      if (symbol <= 2) {
        return 'fas fa-sun text-yellow-300';
      } else if (symbol <= 4) {
        return 'fas fa-cloud-sun';
      } else if (symbol <= 6) {
        return 'fas fa-cloud';
      } else if (symbol <= 7) {
        return 'fas fa-smog';
      } else if (symbol <= 10) {
        return 'fas fa-cloud-showers-heavy';
      } else if (symbol <= 11) {
        return 'fas fa-bolt';
      } else if (symbol <= 14) {
        return 'fas fa-snowflake';
      } else if (symbol <= 17) {
        return 'fas fa-snowflake';
      } else if (symbol <= 20) {
        return 'fas fa-cloud-rain';
      } else if (symbol <= 21) {
        return 'fas fa-bolt';
      } else if (symbol <= 24) {
        return 'fas fa-snowflake';
      } else if (symbol <= 27) {
        return 'fas fa-snowflake';
      }
    }
  }
};
</script>
