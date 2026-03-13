// buscador-componente.js
const BuscadorClientes = {
  template: `
    <q-dialog v-model="visible" @show="enfocar">
      <q-card style="width: 800px; max-width: 90vw; height: 600px;" class="column">
        <q-card-section class="bg-blue-10 text-white row items-center">
          <div class="text-h6">BUSCADOR DE CLIENTES</div>
          <q-space></q-space>
          <q-btn icon="close" flat round dense @click="visible = false" />
        </q-card-section>

        <q-card-section>
          <q-input 
            ref="inputBusq" filled v-model="filtro" label="Buscar..." 
            @update:model-value="filtrar"
            @keydown.down.prevent="bajar" @keydown.up.prevent="subir" @keydown.enter="confirmar"
          />
        </q-card-section>

        <q-card-section class="col q-pa-none">
          <q-table
            flat :rows="filtrados" :columns="cols" row-key="id" hide-pagination :pagination="{rowsPerPage:0}"
          >
            <template v-slot:body="props">
              <q-tr :props="props" @click="seleccionar(props.row)" 
                    :class="{ 'bg-blue-2': props.row.id === activoId }">
                <q-td v-for="col in props.cols" :key="col.name" :props="props">
                  {{ col.value }}
                </q-td>
              </q-tr>
            </template>
          </q-table>
        </q-card-section>
      </q-card>
    </q-dialog>
  `,
  props: ['modelValue'], // Controla si se ve o no
  emits: ['update:modelValue', 'seleccionado'],
  setup(props, { emit }) {
    const visible = Vue.computed({
      get: () => props.modelValue,
      set: (val) => emit('update:modelValue', val)
    })
    
    const filtro = Vue.ref('')
    const filtrados = Vue.ref([])
    const activoId = Vue.ref(null)
    const index = Vue.ref(0)
    const inputBusq = Vue.ref(null)

    const cols = [
      { name: 'codigo', label: 'CÓDIGO', field: 'codigo', align: 'left' },
      { name: 'nombre', label: 'RAZÓN SOCIAL', field: 'nombre', align: 'left' },
      { name: 'cuit', label: 'CUIT', field: 'cuit', align: 'left' }
    ]

    const filtrar = (val) => {
      const q = val.toLowerCase()
      // Usamos la variable global MIS_CLIENTES_REALES
      const base = typeof MIS_CLIENTES_REALES !== 'undefined' ? MIS_CLIENTES_REALES : []
      filtrados.value = base.filter(c => c.nombre.toLowerCase().includes(q) || c.codigo.toString().includes(q)).slice(0, 20)
      index.value = 0
      if(filtrados.value.length > 0) activoId.value = filtrados.value[0].id
    }

    const confirmar = () => {
      const cliente = filtrados.value[index.value]
      if(cliente) {
        emit('seleccionado', cliente)
        visible.value = false
      }
    }

    const seleccionar = (c) => {
        emit('seleccionado', c)
        visible.value = false
    }

    return { visible, filtro, filtrados, cols, activoId, inputBusq, filtrar, confirmar, seleccionar,
             bajar: () => { if(index.value < filtrados.value.length -1) { index.value++; activoId.value = filtrados.value[index.value].id } },
             subir: () => { if(index.value > 0) { index.value--; activoId.value = filtrados.value[index.value].id } },
             enfocar: () => { Vue.nextTick(() => { inputBusq.value.focus(); filtrar(''); }) }
    }
  }
}