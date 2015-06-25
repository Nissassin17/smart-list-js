#by nissassin17
#TODO:
#  - Support dynamic height
#  - Test with dynamic number of rows
#

class AutoOptions
	constructor: (options = {})->
		(@[key] = val if val?) for key, val of options

class Bit
	_currentValue: []
	_data : []

	data : (index) ->
		if @_data[index]?
			@_data[index]
		else
			0
	currentValue: (index)->
		if @_currentValue[index]
			@_currentValue[index]
		else
			0
			
	constructor:(@countMax = 10000)->
	setValue: (index, value)->
		index++
		value -= @currentValue(index)
		@_currentValue[index] = value
		while index < @countMax
			@_data[index] = @data(index) + value
			index += index & (-index)
	getSum: (index)->
		sum = 0
		index++
		while index > 0
			sum += @data(index)
			index -= index & (-index)
		sum
	rupperBound: (val)->
		l = 0
		h = @countMax - 2
		while l < h
			k = Math.floor((l + h) / 2)
			if @getSum(k) < val
				l = k + 1
			else
				h = k - 1
		l
	upperBound: (val)->
		l = 0
		h = @countMax - 2
		while l < h
			k = Math.floor((l + h) / 2)
			if @getSum(k) <= val
				l = k + 1
			else
				h = k - 1
		l


class window.SmartList extends AutoOptions
	#default properties
	numberOfRows: ->0
	heightOfRowAt: (index)-> 0
	contentOfRowAt: (index)-> ""
	root: document
	afterLoad: (dom)->
	countMax: 10000
	
	#number of cached buffers
	bufferLength: 3

	#public methods

	refresh: ->
		@updateNumberOfRows()
		viewPort = @constructor.viewPort()
		firstShownIndex = @bit.upperBound(viewPort.top)
		firstIndex = Math.max(firstShownIndex - @bufferLength, 0)
		lastIndex = Math.min(@bit.rupperBound(viewPort.bottom) + @bufferLength, @_data.length)
		@_data[i].showRefresh(@contentOfRowAt(i), @afterLoad, @heightOfRowAt(i), i < firstShownIndex) for i in [firstIndex...lastIndex] by +1
		(@_data[i].hide() if i < firstIndex || i >= lastIndex) for i in [@lastPost.begin...@lastPost.end] by +1
		@lastPost = begin: firstIndex, end: lastIndex

	#private data

	updateNumberOfRows: ->
		nrows = @numberOfRows()
		if nrows > @_data.length
			for i in [@_data.length...nrows]
				row = new RowWrapper(
					height: @heightOfRowAt i
				)
				@bit.setValue i, @heightOfRowAt i
				@_data.push row
				@root.appendChild row.dom
		else if nrows < @_data.length
			@_data[i].remove(@root) for i in [(@_data.length - 1)..nrows] by -1
			@_data.splace(nrows, @_data.length - nrows)
			@bit.setValue i, 0

	@viewPort:-> top: window.scrollY, bottom: window.scrollY + window.screen.height
	lastPost: begin: 0, end: -1
	_data : []

	constructor: ->
		super
		@bit = new Bit(@countMax)

class RowWrapper extends AutoOptions
	dom: null
	height: 0

	constructor: ->
		super
		@dom = document.createElement "div"
		@dom.style.height = "#{@height}px"


	showRefresh: (content, callback, height, updateTop)->
		unless height == @height
			@dom.style.height = "#{height}px"
			window.scrollY += height - @height if updateTop
			@height = height
		unless @isShown
			@dom.innerHTML = content
			callback(@dom)
			@isShown = true

	hide: ->
		@dom.innerHTML = "" if @isShown
		@isShown = false

	remove: (root)->
		@hide()
		root.removeChild(@dom)
		@dom = null

	#private
	isShown: false
