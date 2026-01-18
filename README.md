# README

# Task Manager API (Rails API Only)

A RESTful backend built using Ruby on Rails (API mode) and MySQL.

## Features
- JWT Authentication (Signup & Login)
- Project Management
- Task Management
- User-based access control
- MySQL database
- Rails 8 API-only architecture

## Tech Stack
- Ruby 3.2.2
- Rails 8.1.2 (API mode)
- MySQL 8
- JWT
- bcrypt

## API Endpoints

### Authentication
POST /signup  
POST /login  

### Projects
GET /projects  
POST /projects  
GET /projects/:id  

### Tasks
POST /projects/:project_id/tasks  
GET /projects/:project_id/tasks  
PATCH /tasks/:id  

## Authentication
All protected routes require:
Authorization: Bearer <JWT_TOKEN>

## Setup Instructions
```bash
bundle install
rails db:create db:migrate
rails s
