#===========================================================
# We'll use this to build the .NET Core code.
#===========================================================
FROM microsoft/dotnet:2.1-sdk AS core-build-step

#copy the code to the image
COPY ./src/ /build/

#move to the build directory
WORKDIR /build/

#restore and publish the bloody agent
RUN dotnet publish \
	--framework netcoreapp2.1 \
	/build/DoubleFreeTest.215/DoubleFreeTest.215.csproj \
    --output /out/

#===========================================================
# Now start making the image that will run on the pi
#===========================================================
FROM microsoft/dotnet:2.1.5-runtime-stretch-slim-arm32v7

#copy the built files over to the device.
COPY --from=core-build-step /out/ /opt/test/

CMD [ "dotnet", "/opt/test/DoubleFreeTest.215.dll" ]