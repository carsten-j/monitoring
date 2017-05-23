FROM microsoft/aspnetcore-build:2.0.0-preview1 as builder
WORKDIR app
ENV ASPNETCORE_URLS http://*:5000
EXPOSE 5000
COPY *.csproj .
RUN dotnet restore
COPY . .
RUN dotnet publish --output out --configuration Release

FROM microsoft/aspnetcore:2.0.0-preview1
WORKDIR /app
COPY --from=builder app/out .
ENTRYPOINT ["dotnet", "aspnetcoreapp.dll"]
