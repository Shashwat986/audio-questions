# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# request permission to access audio stream
window.audio ||= {}

createAudioElement = (blob) ->
  blobUrl = URL.createObjectURL(blob)

  #downloadEl = document.createElement('a')
  downloadEl.style = 'display: block'
  downloadEl.innerHTML = 'download'
  downloadEl.download = 'audio.webm'
  downloadEl.href = blobUrl

  #audioEl = document.createElement('audio')
  audioEl.style = 'display: block'
  audioEl.controls = true
  audioEl.innerHTML = ""
  sourceEl = document.createElement('source')
  sourceEl.src = blobUrl
  sourceEl.type = 'audio/webm'
  audioEl.appendChild sourceEl

  uploadEl.style = 'display: block'
  uploadEl.onclick = (e) ->
    formData = new FormData()

    formData.append('file', blob)

    Rails.ajax
      url: uploadEl.dataset.posturl
      type: "POST"
      data: formData
      success: (data) ->
        if data.status? and data.status
          Turbolinks.visit(uploadEl.dataset.nexturl)
        else
          alert 'There was an error uploading the file. Please try again'
      error: () ->
        alert 'There was an error uploading the file. Please try again'

window.audio.startRecording = () ->
  navigator.mediaDevices.getUserMedia(audio: true).then((stream) ->
    # store streaming data chunks in array
    chunks = []
    # create media recorder instance to initialize recording
    window.audio.recorder = new MediaRecorder(stream)
    recorder = window.audio.recorder
    # function to be called when data is received

    recorder.onstart = (e) ->
      recordingStatus.innerHTML = "Recording"

    recorder.ondataavailable = (e) ->
      # add stream data to chunks
      chunks.push e.data
      # if recorder is 'inactive' then recording has finished
      if recorder.state == 'inactive'
        # convert stream data chunks to a 'webm' audio format as a blob
        blob = new Blob(chunks, type: 'audio/webm')
        # convert blob to URL so it can be assigned to a audio src attribute
        createAudioElement blob
      return

    # start recording with 1 second time between receiving 'ondataavailable' events
    recorder.start 1000
  ).catch(console.error)

window.audio.stopRecording = () ->
  window.audio.recorder.stop()
  recordingStatus.innerHTML = "Recording done"
