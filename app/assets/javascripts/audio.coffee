# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# request permission to access audio stream
window.audio ||= {}

createAudioElement = (blob) ->
  blobUrl = URL.createObjectURL(blob)
  submitContainerEl.classList.remove('is-hidden')

  uploadEl.disabled = false
  uploadEl.innerHTML = "Submit Recording"
  window.audio.submitted = false

  audioEl.controls = true
  audioEl.innerHTML = ""
  sourceEl = document.createElement('source')
  sourceEl.src = blobUrl
  sourceEl.type = 'audio/webm'
  audioEl.appendChild sourceEl
  audioEl.load()

  uploadEl.onclick = (e) ->
    formData = new FormData()

    formData.append('file', blob)

    uploadEl.classList.add('is-loading')
    Rails.ajax
      url: uploadEl.dataset.posturl
      type: "POST"
      data: formData
      success: (data) ->
        window.audio.submitted = true
        uploadEl.classList.remove('is-loading')
        if data.status? and data.status
          Turbolinks.visit(uploadEl.dataset.nexturl)
        else
          alert 'There was an error uploading the file. Please try again'
      error: () ->
        uploadEl.classList.remove('is-loading')
        alert 'There was an error uploading the file. Please try again'

window.audio.navigationGuard = (e) ->
  if window.audio.submitted? && window.audio.submitted == false
    reply = confirm("You have not submitted your audio file. Are you sure you want to leave?")
    if reply
      window.audio.submitted = undefined
    else
      e.preventDefault()
      return

  Turbolinks.visit(e.currentTarget.dataset.href)

window.audio.startRecording = () ->
  navigator.mediaDevices.getUserMedia(audio: true).then((stream) ->
    # store streaming data chunks in array
    window.audio.chunks = []
    # create media recorder instance to initialize recording
    window.audio.recorder = new MediaRecorder(stream)
    recorder = window.audio.recorder
    # function to be called when data is received

    recorder.onstart = (e) ->
      window.audio.submitted = false
      recordingStatus.classList.remove('is-hidden')

      startRecordingEl.classList.add('is-hidden')
      stopRecordingEl.classList.remove('is-hidden')
      submitContainerEl.classList.add('is-hidden')

    recorder.ondataavailable = (e) ->
      # add stream data to chunks
      window.audio.chunks.push e.data
      # if recorder is 'inactive' then recording has finished
      if recorder.state == 'inactive'
        # convert stream data chunks to a 'webm' audio format as a blob
        blob = new Blob(window.audio.chunks, type: 'audio/webm')
        # convert blob to URL so it can be assigned to a audio src attribute
        createAudioElement blob
      return

    # start recording with 1 second time between receiving 'ondataavailable' events
    recorder.start 1000
  ).catch(console.error)

window.audio.stopRecording = () ->
  window.audio.recorder.stop()
  recordingStatus.classList.add('is-hidden')
  startRecordingEl.classList.remove('is-hidden')
  stopRecordingEl.classList.add('is-hidden')

window.audio.resultOnLoad = () ->
  codeEl.innerHTML = window.location
