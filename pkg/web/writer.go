package web

import (
	"bytes"
	"net/http"
)

// ResponseBufferWriter 自定义Write
type ResponseBufferWriter struct {
	http.ResponseWriter
	buf *bytes.Buffer
}

// NewResponseBufferWriter ..
func NewResponseBufferWriter(w http.ResponseWriter) *ResponseBufferWriter {
	ww := &ResponseBufferWriter{
		ResponseWriter: w,
		buf:            bytes.NewBuffer(nil),
	}
	return ww
}

// Write http write 接口实现
func (w *ResponseBufferWriter) Write(data []byte) (int, error) {
	return w.buf.Write(data)
}

// Buff ..
func (w *ResponseBufferWriter) Buff() []byte {
	return w.buf.Bytes()
}
