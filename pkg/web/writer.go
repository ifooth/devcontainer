package web

import (
	"bytes"
	"net/http"
)

// ResponseBufferWriter 自定义Write
type ResponseBufferWriter interface {
	http.ResponseWriter
	Buff() []byte
}

// bufferWriter ..
type bufferWriter struct {
	http.ResponseWriter
	buf *bytes.Buffer
}

// NewResponseBufferWriter ..
func NewResponseBufferWriter(w http.ResponseWriter) ResponseBufferWriter {
	ww := &bufferWriter{
		ResponseWriter: w,
		buf:            bytes.NewBuffer(nil),
	}
	return ww
}

// Write http write 接口实现
func (w *bufferWriter) Write(data []byte) (int, error) {
	return w.buf.Write(data)
}

// Buff ..
func (w *bufferWriter) Buff() []byte {
	return w.buf.Bytes()
}
