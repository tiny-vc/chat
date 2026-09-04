import { INestApplication } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { DocumentBuilder, OpenAPIObject, SwaggerModule } from '@nestjs/swagger';
import { apiResponseSchemas, operationResponseSchemas } from './openapi-schemas';

const publicOperations = new Set([
  'GET /api/v1/server-info',
  'GET /api/v1/health',
  'GET /api/v1/ready',
  'POST /api/v1/auth/register',
  'POST /api/v1/auth/login',
  'POST /api/v1/auth/refresh',
  'GET /api/v1/messages/protocol',
  'POST /api/v1/webhooks/wukongim',
]);

export function createOpenApiDocument(app: INestApplication): OpenAPIObject {
  const config = app.get(ConfigService);
  const documentConfig = new DocumentBuilder()
    .setTitle('Chat Server API')
    .setDescription('Flutter chat backend powered by WuKongIM, LiveKit and S3-compatible storage.')
    .setVersion('1.0.0')
    .addServer(config.getOrThrow<string>('API_PUBLIC_URL'))
    .addBearerAuth(
      { type: 'http', scheme: 'bearer', bearerFormat: 'JWT', description: 'Business access token' },
      'access-token',
    )
    .build();
  const document = SwaggerModule.createDocument(app, documentConfig, {
    operationIdFactory: (controllerKey, methodKey) => `${controllerKey.replace(/Controller$/, '')}_${methodKey}`,
  });

  document.components ??= {};
  document.components.schemas ??= {};
  document.components.schemas.ErrorResponse = {
    type: 'object',
    required: ['statusCode', 'code', 'message', 'requestId', 'timestamp', 'path'],
    properties: {
      statusCode: { type: 'integer', example: 400 },
      code: { type: 'string', example: 'BAD_REQUEST' },
      message: { type: 'string' },
      details: { type: 'object', additionalProperties: true },
      requestId: { type: 'string', nullable: true },
      timestamp: { type: 'string', format: 'date-time' },
      path: { type: 'string' },
    },
  };
  Object.assign(document.components.schemas, apiResponseSchemas);

  for (const [path, pathItem] of Object.entries(document.paths)) {
    for (const [method, operation] of Object.entries(pathItem ?? {})) {
      if (!['get', 'post', 'put', 'patch', 'delete'].includes(method) || !operation) continue;
      const typed = operation as {
        operationId?: string;
        security?: Array<Record<string, string[]>>;
        responses?: Record<string, unknown>;
      };
      if (!publicOperations.has(`${method.toUpperCase()} ${path}`)) {
        typed.security = [{ 'access-token': [] }];
      }
      typed.responses ??= {};
      const response = typed.operationId ? operationResponseSchemas[typed.operationId] : undefined;
      if (response) {
        const item = { $ref: `#/components/schemas/${response.schema}` };
        typed.responses[method === 'post' ? '201' : '200'] = {
          description: 'Successful response',
          content: {
            'application/json': {
              schema: response.array ? { type: 'array', items: item } : item,
            },
          },
        };
      } else {
        const successStatus = method === 'post' ? '201' : '200';
        const currentResponse = typed.responses[successStatus] as
          | { content?: unknown; description?: string }
          | undefined;
        if (!currentResponse?.content) {
          typed.responses[successStatus] = {
            description: currentResponse?.description ?? 'Successful response',
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/GenericObjectResponse' },
              },
            },
          };
        }
      }
      for (const status of ['400', '401', '403', '500']) {
        typed.responses[status] ??= {
          description: status === '500' ? 'Internal server error' : 'Request rejected',
          content: {
            'application/json': { schema: { $ref: '#/components/schemas/ErrorResponse' } },
          },
        };
      }
    }
  }
  return document;
}

export function setupOpenApi(app: INestApplication) {
  const config = app.get(ConfigService);
  if (config.getOrThrow<string>('SWAGGER_ENABLED') !== 'true') return;
  const document = createOpenApiDocument(app);
  SwaggerModule.setup('docs', app, document, {
    useGlobalPrefix: true,
    jsonDocumentUrl: '/openapi.json',
    swaggerOptions: { persistAuthorization: true, displayRequestDuration: true },
  });
}
