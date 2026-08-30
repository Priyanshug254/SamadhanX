package com.samadhanx.module.auth.controller;

import com.samadhanx.common.response.ApiResponse;
import com.samadhanx.module.auth.dto.AuthResponse;
import com.samadhanx.module.auth.dto.LoginRequest;
import com.samadhanx.module.auth.dto.RegisterRequest;
import com.samadhanx.module.auth.service.AuthService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.security.SecurityRequirements;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication", description = "Endpoints for user registration and JWT authentication")
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    @SecurityRequirements // Public endpoint, no JWT required
    @Operation(summary = "Register new account", description = "Public self-registration for citizens, students, faculty, organizations, startups, etc.")
    public ResponseEntity<ApiResponse<AuthResponse>> register(@Valid @RequestBody RegisterRequest request) {
        AuthResponse authResponse = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.created("Account successfully registered", authResponse));
    }

    @PostMapping("/login")
    @SecurityRequirements // Public endpoint, no JWT required
    @Operation(summary = "User login", description = "Authenticate with email and password to receive a JWT access token")
    public ResponseEntity<ApiResponse<AuthResponse>> login(@Valid @RequestBody LoginRequest request) {
        AuthResponse authResponse = authService.login(request);
        return ResponseEntity.ok(ApiResponse.ok("Login successful", authResponse));
    }
}
