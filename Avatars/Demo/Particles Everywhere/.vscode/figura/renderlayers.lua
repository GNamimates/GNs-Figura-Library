--================================================================================================--
--=====  CLASSES  ================================================================================--
--================================================================================================--

--- Contains the Finctions for controlling the shaders
renderlayers = {}

--- Returns true or false depending on if the shader exists yet
---@param shaderName string
function renderlayers.isShaderReady(shaderName) end

--- Gets the priority of the chosen render layer, or nil if it doesn't exist
---@param renderLayerName string
function renderlayers.getPriority(renderLayerName) end

--- Registers a new render layer with the given name
--- → params is a table where you can set certain keys
--- → startFunction and endFunction - are two lua functions, called when you start rendering and when you stop
--- → vertexFormat - needs to match with the format of any shader you want to use. Same default as in registerShader() 
--- → hasCrumbling - don't know what this does, but it's true by default
--- → translucent - also don't know this one, but true by default rendering this layer. Functions which interact with openGL can only be called inside these
---@param name string
---@param params table
---@param startFunction function
---@param endFunction function
function renderlayers.registerRenderLayer(name, params, startFunction, endFunction) end

--- → Registers a new custom shader with the given name
--- → If format is nil, uses the default of "POSITION_COLOR_TEXTURE_OVERLAY_LIGHT_NORMAL"
--- → Code for the shader is contained in strings, vertexSource and fragmentSource
---@param name string
---@param format string
---@param vertexSource string
---@param fragmentSource string
---@param numSamplers string
---@param customUniforms string
function renderlayers.registerShader(name, format, vertexSource, fragmentSource, numSamplers, customUniforms) end

---Resets the rendering to default state.
function renderlayers.restoreDefaults() end