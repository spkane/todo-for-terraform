// Code generated by go-swagger; DO NOT EDIT.

package todos

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	"net/http"

	"github.com/go-openapi/runtime"

	models "github.com/spkane/todo-api-example/models"
)

// FindTodoOKCode is the HTTP code returned for type FindTodoOK
const FindTodoOKCode int = 200

/*FindTodoOK list the todo

swagger:response findTodoOK
*/
type FindTodoOK struct {

	/*
	  In: Body
	*/
	Payload []*models.Item `json:"body,omitempty"`
}

// NewFindTodoOK creates FindTodoOK with default headers values
func NewFindTodoOK() *FindTodoOK {

	return &FindTodoOK{}
}

// WithPayload adds the payload to the find todo o k response
func (o *FindTodoOK) WithPayload(payload []*models.Item) *FindTodoOK {
	o.Payload = payload
	return o
}

// SetPayload sets the payload to the find todo o k response
func (o *FindTodoOK) SetPayload(payload []*models.Item) {
	o.Payload = payload
}

// WriteResponse to the client
func (o *FindTodoOK) WriteResponse(rw http.ResponseWriter, producer runtime.Producer) {

	rw.WriteHeader(200)
	payload := o.Payload
	if payload == nil {
		// return empty array
		payload = make([]*models.Item, 0, 50)
	}

	if err := producer.Produce(rw, payload); err != nil {
		panic(err) // let the recovery middleware deal with this
	}
}

/*FindTodoDefault generic error response

swagger:response findTodoDefault
*/
type FindTodoDefault struct {
	_statusCode int

	/*
	  In: Body
	*/
	Payload *models.Error `json:"body,omitempty"`
}

// NewFindTodoDefault creates FindTodoDefault with default headers values
func NewFindTodoDefault(code int) *FindTodoDefault {
	if code <= 0 {
		code = 500
	}

	return &FindTodoDefault{
		_statusCode: code,
	}
}

// WithStatusCode adds the status to the find todo default response
func (o *FindTodoDefault) WithStatusCode(code int) *FindTodoDefault {
	o._statusCode = code
	return o
}

// SetStatusCode sets the status to the find todo default response
func (o *FindTodoDefault) SetStatusCode(code int) {
	o._statusCode = code
}

// WithPayload adds the payload to the find todo default response
func (o *FindTodoDefault) WithPayload(payload *models.Error) *FindTodoDefault {
	o.Payload = payload
	return o
}

// SetPayload sets the payload to the find todo default response
func (o *FindTodoDefault) SetPayload(payload *models.Error) {
	o.Payload = payload
}

// WriteResponse to the client
func (o *FindTodoDefault) WriteResponse(rw http.ResponseWriter, producer runtime.Producer) {

	rw.WriteHeader(o._statusCode)
	if o.Payload != nil {
		payload := o.Payload
		if err := producer.Produce(rw, payload); err != nil {
			panic(err) // let the recovery middleware deal with this
		}
	}
}
