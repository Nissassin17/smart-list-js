class AutoOptions
	constructor: (options = {})->
		(@[key] = val if val?) for key, val of options


class window.SmartList extends AutoOptions
	#default properties
	numberOfRows: ->0
	heightOfRowAt: (index)-> 0
	contentOfRowAt: (index)-> ""
	root: document
	afterLoad: (dom)->
	
	#number of cached buffers
	bufferLength: 3

	#public methods

	refresh: ->
		top = 0
		cnt = @bufferLength
		toHideList = []
		found = false
		for i in [0...@_numberOfRows()]
			row = @_data[i]
			rowHeight = row.updateHeight(@heightOfRowAt(i), toHideList.length == 0)
			if @constructor.viewPortBottom() > top > @constructor.viewPortTop() or @constructor.viewPortTop() < top + rowHeight < @constructor.viewPortBottom()
				row.show(@contentOfRowAt(i), @afterLoad)
				found = true
			else
				unless found
					toHideList.push i
				else
					if cnt > 0
						cnt--
						row.show(@contentOfRowAt(i), @afterLoad)
					else
						row.hide()

			top += rowHeight

		cnt = @bufferLength
		i = toHideList.length - 1
		while i > 0
			row = @_data[toHideList[i]]
			if (cnt > 0)
				row.show(@contentOfRowAt(toHideList[i]), @afterLoad)
			else
				row.hide()
			i--
			cnt--
		toHideList.length = 0

	#private data

	_numberOfRows: ()->
		nrows = @numberOfRows()
		if nrows > @_data.length
			for i in [@_data.length...nrows]
				row = new RowWrapper(
					height: @heightOfRowAt i
				)
				@_data.push row
				@root.appendChild row.dom
		else if nrows < @_data.length
			@_data[i].remove(@root) for i in [(@_data.length - 1)..nrows] by -1
			@_data.splace(nrows, @_data.length - nrows)
		nrows

	@viewPortTop:-> window.scrollY
	@viewPortBottom: ->window.scrollY + window.screen.height
	_data : []


class RowWrapper extends AutoOptions
	dom: null
	height: 0

	updateHeight: (height, updateTop)->
		unless height == @height
			@dom.style.height = "#{height}px"
			window.scrollY += height - @height if updateTop
			@height = height
		height

	constructor: ->
		super
		@dom = document.createElement "div"
		@dom.style.height = "#{@height}px"


	#TODO: update height each time show
	show: (content, callback)->
		#TODO: update content if height changed
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
